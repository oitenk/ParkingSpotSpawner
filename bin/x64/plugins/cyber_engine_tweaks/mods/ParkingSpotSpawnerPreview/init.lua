-- Parking Spot Spawner - what the mod draws in the world, through XUtils
-- Draws a post and the vehicle's outline while a parking spot is being placed, and
-- paints the word PARKING on the ground at each saved spot. The keys, the layout, the
-- settings, the spot's prompt and the vehicles live in r6/scripts/ParkingSpotSpawner;
-- this only draws what that works out. There the word's place is the spot's "meter".

local BRIDGE = "ParkingSpotSpawner.PSSBridge"
local SYSTEM = "ParkingSpotSpawner.PSSSystem"

-- How tall the post is that shows, while placing, where the word will go.
local POST_HEIGHT = 1.3
-- How far away, in metres, a ground marking stops being drawn.
local MARKING_HIDE_DISTANCE = 150

local XU = nil
local handle = nil
local placing = false
local system = nil    -- the Redscript system, looked up once per session
local preview = nil   -- what is drawn while placing: { post, lines, visible }
local markers = {}    -- what marks each saved spot, by spot id: { marking }
local restoring = 0   -- frames left to keep trying to mark the saved spots
local markingStyle = nil -- the ground marking settings the markings were last painted with
local styleTicks = 0  -- frames since the settings were last checked

-- Handle calls return XU.DEFERRED, not an id, when XUtils is not ready yet.
local function spawned(id)
    return id ~= nil and id ~= false and id ~= XU.DEFERRED
end

local function getSystem()
    if system and IsDefined(system) then return system end
    local container = Game.GetScriptableSystemsContainer()
    system = container and container:Get(CName.new(SYSTEM)) or nil
    return system
end

local function raised(point, height)
    return Vector4.new(point.x, point.y, point.z + height, 1.0)
end

-- XUtils anchors a line at its start and turns it toward its end. This is the same
-- turn, so a line whose length does not change can be moved without respawning it.
local function lineTransform(from, to)
    local rot = Vector4.new(to.x - from.x, to.y - from.y, to.z - from.z, 0):ToRotation()
    return { position = from, rotation = EulerAngles.new(rot.pitch, 0, rot.yaw + 90) }
end

local function markingShown(style)
    return style:sub(1, 1) == "1"
end

-- Paints a spot's ground marking: an empty entity at its place with a decal hung on it.
-- A decal is as large as its scale in metres and lies on whatever ground is within its
-- depth. Its material has to be there before the decal is added, so that is waited
-- for. Returns the entity's id, or nil when it could not be spawned.
local function spawnMarking(sys, index)
    local material = sys:GetMarkingMaterial()
    local size = sys:GetMarkingSize()
    local id = handle:SpawnEntity({
        position = sys:GetSpotMarking(index),
        rotation = EulerAngles.new(0, 0, sys:GetSpotMarkingYaw(index)),
        onAssemble = function(entity)
            local decal = entDecalComponent.new()
            decal.name = CName.new("pss_marking")
            ResourceHelper.LoadReferenceResource(decal, "material", material, true)
            decal.visualScale = Vector3.new(size.x, size.y, size.z)
            decal.aspectRatio = 1
            decal.alpha = 1
            decal.autoHideDistance = MARKING_HIDE_DISTANCE
            entity:AddComponent(decal)
            local owner = getSystem()
            if owner then owner:NoteMarking(material, ResourceHelper.IsReferenceLoaded(decal, "material")) end
        end,
    })
    return spawned(id) and id or nil
end

-- Marks a saved spot by painting its ground marking, when that is switched on. Nil
-- when XUtils could not spawn yet.
local function standMarker(sys, index)
    markingStyle = sys:GetMarkingStyle()
    if not markingShown(markingStyle) then return {} end
    local marking = spawnMarking(sys, index)
    return marking and { marking = marking } or nil
end

local function removeMarker(marker)
    if marker.marking then handle:DespawnEntity(marker.marking) end
end

-- Marks every spot that came back with the save. Early in a session the spots may not
-- be loaded yet and XUtils may not be ready to spawn, so this is repeated: until
-- every spot is marked, or for as long as there are none to see.
local function restoreMarkers()
    restoring = restoring - 1
    local sys = getSystem()
    if not sys then return end
    local count = sys:GetSpotCount()
    local missing = false
    for index = 0, count - 1 do
        local id = sys:GetSpotID(index)
        if not markers[id] then
            markers[id] = standMarker(sys, index)
            if not markers[id] then missing = true end
        end
    end
    if count > 0 and not missing then restoring = 0 end
end

-- Paints the ground markings afresh when the settings for them have changed.
local function refreshSettings()
    if next(markers) == nil then return end
    local sys = getSystem()
    if not sys then return end
    local marking = sys:GetMarkingStyle()
    if marking == markingStyle then return end
    markingStyle = marking
    for index = 0, sys:GetSpotCount() - 1 do
        local marker = markers[sys:GetSpotID(index)]
        if marker then
            if marker.marking then handle:DespawnEntity(marker.marking) end
            marker.marking = markingShown(marking) and spawnMarking(sys, index) or nil
        end
    end
end

-- The vehicle's outline as line segments, a little off the ground: the front edge,
-- the other three, then a line from the centre to the middle of the front.
local function outlineSegments(sys)
    local centre = raised(sys:GetPreviewPoint(1), 0.05)
    local frontLeft = raised(sys:GetPreviewPoint(2), 0.05)
    local frontRight = raised(sys:GetPreviewPoint(3), 0.05)
    local rearRight = raised(sys:GetPreviewPoint(4), 0.05)
    local rearLeft = raised(sys:GetPreviewPoint(5), 0.05)
    local nose = Vector4.new((frontLeft.x + frontRight.x) / 2, (frontLeft.y + frontRight.y) / 2,
        (frontLeft.z + frontRight.z) / 2, 1.0)
    return {
        { frontLeft, frontRight },
        { frontRight, rearRight },
        { rearRight, rearLeft },
        { rearLeft, frontLeft },
        { centre, nose },
    }
end

local function setPreviewVisible(visible)
    if not preview or preview.visible == visible then return end
    preview.visible = visible
    local ids = { preview.post }
    for i = 1, 5 do
        if spawned(preview.lines[i]) then ids[#ids + 1] = preview.lines[i] end
    end
    handle:SetShapesVisible(ids, visible)
end

local function clearPreview()
    if not preview then return end
    for i = 1, 5 do
        if spawned(preview.lines[i]) then handle:DespawnShape(preview.lines[i]) end
    end
    handle:DespawnShape(preview.post)
    preview = nil
end

local function drawPreview(sys)
    local place = sys:GetPreviewPoint(0)
    local segments = outlineSegments(sys)

    if not preview then
        -- A thin post marks where the word will go and the spot will be used from.
        local post = handle:SpawnLine(place, raised(place, POST_HEIGHT), { thickness = 0.04, color = "lime" })
        if not spawned(post) then return end
        preview = { post = post, lines = {}, visible = true }
        for i = 1, 5 do
            -- The front edge and the line to it are red, so the nose is easy to tell.
            local color = (i == 1 or i == 5) and "red" or "cyan"
            preview.lines[i] = handle:SpawnLine(segments[i][1], segments[i][2], { thickness = 0.03, color = color })
        end
        return
    end

    handle:SetShapeTransform(preview.post, { position = place })
    for i = 1, 5 do
        if spawned(preview.lines[i]) then
            handle:SetShapeTransform(preview.lines[i], lineTransform(segments[i][1], segments[i][2]))
        end
    end
    setPreviewVisible(true)
end

registerForEvent("onInit", function()
    XU = GetMod("XUtils")
    if not XU then
        print("[ParkingSpotSpawnerPreview] XUtils not found - the placement preview and the PARKING markings are disabled")
        return
    end
    handle = XU.Subscribe("ParkingSpotSpawner")
    if not handle then
        print("[ParkingSpotSpawnerPreview] XUtils did not give a handle - the placement preview and the PARKING markings are disabled")
        return
    end

    Override(BRIDGE, "HasPreview;Bool", function(fallback)
        return true
    end)

    Override(BRIDGE, "PlacementChanged;Bool", function(active)
        placing = active
        if not active then clearPreview() end
    end)

    Override(BRIDGE, "SpotPlaced;Int32", function(id)
        local sys = getSystem()
        if not sys then return end
        for index = 0, sys:GetSpotCount() - 1 do
            if sys:GetSpotID(index) == id then markers[id] = standMarker(sys, index) end
        end
    end)

    Override(BRIDGE, "SpotRemoved;Int32", function(id)
        if markers[id] then removeMarker(markers[id]) end
        markers[id] = nil
    end)

    -- XUtils has already removed everything the handle spawned by the time this fires.
    XU.Events.on("session_cleanup", function()
        placing = false
        system = nil
        preview = nil
        markers = {}
        restoring = 0
        markingStyle = nil
    end)

    -- A save with spots in it has been loaded.
    Override(BRIDGE, "SpotsRestored;Int32", function(count)
        system = nil
        restoring = 600
    end)

    -- Runs once the player is in the world, in every session.
    handle:WhenReady(function()
        system = nil
        restoring = 600
    end)
end)

registerForEvent("onUpdate", function()
    if restoring > 0 then restoreMarkers() end
    -- About once a second, pick up a change to the ground marking settings.
    styleTicks = styleTicks + 1
    if styleTicks >= 60 then
        styleTicks = 0
        refreshSettings()
    end
    if not placing then return end
    local sys = getSystem()
    if sys and sys:UpdatePreview() then
        drawPreview(sys)
    else
        setPreviewVisible(false)
    end
end)
