// Parking Spot Spawner: mark a parking spot with the word PARKING painted
// on the ground, line up where its vehicle should stand, then walk up to the word to
// bring one of your owned vehicles out or put it away. In the code the word's place
// is the spot's "meter", after the parking meter that first marked it. Spots are kept
// in the save they were placed in.
// The keys are set in Mod Settings.
module ParkingSpotSpawner

public class PSSSettings {
  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "Place a parking spot (press again for each step)")
  public let placeKey: EInputKey = EInputKey.IK_F6;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "Change which way the vehicle faces")
  public let facingKey: EInputKey = EInputKey.IK_F7;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "Stop placing / remove the nearest parking spot")
  public let clearKey: EInputKey = EInputKey.IK_F8;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "Lock / unlock a parking spot")
  @runtimeProperty("ModSettings.description", "A locked spot cannot be removed until it is unlocked. Acts on the spot you are looking at, or else on the nearest one within five metres.")
  public let lockKey: EInputKey = EInputKey.IK_F10;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "At a parking spot: bring the vehicle out / put it away")
  @runtimeProperty("ModSettings.description", "The prompt on a parking spot shows the game's own first interaction key, so keep this the same as that.")
  public let useKey: EInputKey = EInputKey.IK_F;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "At a parking spot: choose vehicle")
  @runtimeProperty("ModSettings.description", "The prompt on a parking spot shows the game's own second interaction key, so keep this the same as that.")
  public let chooseKey: EInputKey = EInputKey.IK_R;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "While placing: swing the vehicle left around the marking")
  public let swingLeftKey: EInputKey = EInputKey.IK_Comma;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "While placing: swing the vehicle right around the marking")
  public let swingRightKey: EInputKey = EInputKey.IK_Period;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "While placing: vehicle further from the marking")
  public let furtherKey: EInputKey = EInputKey.IK_Up;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "While placing: vehicle closer to the marking")
  public let closerKey: EInputKey = EInputKey.IK_Down;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "While placing: vehicle to the left")
  public let leftKey: EInputKey = EInputKey.IK_Left;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.displayName", "While placing: vehicle to the right")
  public let rightKey: EInputKey = EInputKey.IK_Right;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Vehicles")
  @runtimeProperty("ModSettings.displayName", "Bring vehicles out through the game's own vehicle call")
  @runtimeProperty("ModSettings.description", "On: the game delivers your vehicle and the mod stands it on the spot, so it counts as yours everywhere, and the game's rules for calling vehicles apply. Off: the mod spawns a copy of its own, which works anywhere but is not treated as your vehicle by the game or by other mods.")
  public let ownVehicles: Bool = true;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Ground Marking")
  @runtimeProperty("ModSettings.displayName", "Show the PARKING marking")
  @runtimeProperty("ModSettings.description", "Paints the word PARKING on the ground where each saved spot is used from.")
  public let marking: Bool = true;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Ground Marking")
  @runtimeProperty("ModSettings.displayName", "Marking width (cm)")
  @runtimeProperty("ModSettings.description", "How wide the word is.")
  @runtimeProperty("ModSettings.step", "10.0")
  @runtimeProperty("ModSettings.min", "50.0")
  @runtimeProperty("ModSettings.max", "600.0")
  public let markingWidth: Float = 240.0;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Ground Marking")
  @runtimeProperty("ModSettings.displayName", "Marking height (cm)")
  @runtimeProperty("ModSettings.description", "How tall the letters are.")
  @runtimeProperty("ModSettings.step", "5.0")
  @runtimeProperty("ModSettings.min", "10.0")
  @runtimeProperty("ModSettings.max", "300.0")
  public let markingHeight: Float = 60.0;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Remove Parking Spots")
  @runtimeProperty("ModSettings.displayName", "Remove all parking spots that are not locked")
  @runtimeProperty("ModSettings.description", "Switch this on to remove every unlocked parking spot in the save you are playing, wherever it is. It is done once, when you are back in the game, and the switch turns itself off again. Switched on from the main menu it does nothing.")
  public let removeUnlocked: Bool = false;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Remove Parking Spots")
  @runtimeProperty("ModSettings.displayName", "Remove every parking spot, locked ones too")
  @runtimeProperty("ModSettings.description", "Switch this on to remove every parking spot in the save you are playing, locked or not. It is done once, when you are back in the game, and the switch turns itself off again. Switched on from the main menu it does nothing.")
  public let removeEverything: Bool = false;

  @runtimeProperty("ModSettings.mod", "Parking Spot Spawner")
  @runtimeProperty("ModSettings.category", "Debug")
  @runtimeProperty("ModSettings.displayName", "Debug logging")
  public let debug: Bool = false;
}

// Which way a parked vehicle points. Left and right are as seen from the meter,
// looking at the vehicle.
enum PSSFacing {
  TowardMeter = 0,
  AwayFromMeter = 1,
  SideLeft = 2,
  SideRight = 3
}

// Placing takes two steps: first the meter follows the crosshair, then it stays put
// while the vehicle is lined up around it.
enum PSSStage {
  Idle = 0,
  Meter = 1,
  Vehicle = 2
}

// A parking spot. Everything but the vehicle standing on it is kept in the save.
public class PSSSpot {
  public persistent let id: Int32;
  public persistent let meter: Vector4;
  // No longer used: the turn of the parking meter that earlier builds stood there.
  // Kept, like the line spacing below, so that saves made with those builds load as
  // they are.
  public persistent let meterYaw: Float;
  public persistent let position: Vector4;
  // The vehicle's heading as a plain number: a rotation does not come back from a save.
  public persistent let yaw: Float;
  // No longer used: the distance between the parking lines that earlier builds drew.
  public persistent let lineSpacing: Float;
  // The vehicle this spot brings out, and the one it last brought out, if any.
  public persistent let vehicle: TweakDBID;
  // A locked spot cannot be removed until it is unlocked.
  public persistent let locked: Bool;
  public let parked: EntityID;
}

// Hooks for the mod's Lua part, which draws through XUtils and overrides them from its init.lua.
// The bodies below are what runs without it.
public abstract class PSSBridge {
  // True when something is drawing the preview, so placing can be done in steps.
  public static func HasPreview(fallback: Bool) -> Bool {
    return fallback;
  }

  public static func PlacementChanged(active: Bool) -> Void {}

  // A spot was saved.
  public static func SpotPlaced(id: Int32) -> Void {}

  public static func SpotRemoved(id: Int32) -> Void {}

  // A save was loaded with this many spots in it.
  public static func SpotsRestored(count: Int32) -> Void {}
}

public class PSSTickCallback extends DelayCallback {
  public let m_system: wref<PSSSystem>;
  public let m_generation: Int32;

  public func Call() -> Void {
    if IsDefined(this.m_system) { this.m_system.OnTick(this.m_generation); }
  }
}

public class PSSSystem extends ScriptableSystem {
  private let m_settings: ref<PSSSettings>;
  private persistent let m_spots: array<ref<PSSSpot>>;
  private persistent let m_nextSpotID: Int32;

  // Placing. The gap is the space between the meter and the nearest side of the
  // vehicle, the side shift is to the right, and the swing turns both around the meter.
  private let m_stage: PSSStage;
  private let m_facing: PSSFacing;
  private let m_gap: Float = 1.0;
  private let m_side: Float;
  private let m_swing: Float;
  private let m_meter: Vector4;
  private let m_front: Vector4;
  // The layout last worked out: the meter, the vehicle's centre, then its corners
  // front left, front right, rear right, rear left.
  private let m_points: array<Vector4>;
  private let m_yaw: Float;
  // The two "remove all" switches in Mod Settings as they last stood, once they have
  // been looked at: a switch going from off to on is what carries its command out.
  private let m_switchesSeen: Bool;
  private let m_removeUnlockedWas: Bool;
  private let m_removeEverythingWas: Bool;
  private let m_switchResetTried: Bool;

  // The tick. Each restart gets a new generation, so a tick from an earlier run stops
  // itself, and the time of the last one shows when the run has died.
  private let m_ticking: Bool;
  private let m_tickGeneration: Int32;
  private let m_tickTime: Float;

  // The meter prompt: the spot it is up for, and the vehicle it offers to put away.
  private let m_hubSpot: ref<PSSSpot>;
  private let m_hubVehicle: wref<VehicleObject>;
  private let m_hubBlocked: Bool;
  private let m_hubSignature: String;

  // Bringing one of the game's own vehicles out, step by step: 1 waits for the copy
  // already in the world to go, 2 waits for the new one to appear, 3 keeps it on the
  // spot while it comes to rest. The summon mode is switched for the request only.
  private let m_bringStage: Int32;
  private let m_bringTicks: Int32;
  private let m_bringSpot: ref<PSSSpot>;
  private let m_bringVehicle: PlayerVehicle;
  private let m_bringOldID: EntityID;
  private let m_summonModeSwitched: Bool;
  // The vehicle the player last rode in.
  private let m_lastVehicle: wref<VehicleObject>;
  // Debug: the game's garage component and what was last logged about it.
  private let m_garage: wref<GarageComponent>;
  private let m_garageLog: String;

  // Choosing a vehicle from the game's own vehicle list: the spot it is for, whether
  // the list has come up yet, and whether a choice has been made in it.
  private let m_chooseSpot: ref<PSSSpot>;
  private let m_chooseTicks: Int32;
  private let m_chooseOpened: Bool;
  private let m_chosen: Bool;

  private func OnAttach() -> Void {
    this.m_settings = new PSSSettings();
    PSS_RegisterSettings(this.m_settings);
    GameInstance.GetCallbackSystem().RegisterCallback(n"Input/Key", this, n"OnKeyInput");
    GameInstance.GetDynamicEntitySystem().RegisterListener(n"ParkingSpotSpawner", this, n"OnParkedVehicleEvent");
  }

  private func OnDetach() -> Void {
    this.RestoreSummonMode();
    PSS_UnregisterSettings(this.m_settings);
  }

  // Spots come back with a loaded save, and their prompts need the tick running again.
  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    for spot in this.m_spots {
      this.Log("restored spot " + ToString(spot.id) + ": meter at " + ToString(spot.meter) + ", vehicle at " + ToString(spot.position)
          + " turned " + FloatToStringPrec(spot.yaw, 1) + ", " + TDBID.ToStringDEBUG(spot.vehicle) + (spot.locked ? ", locked" : ""));
    }
    PSSBridge.SpotsRestored(ArraySize(this.m_spots));
    this.StartTicking();
  }

  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.StartTicking();
  }

  protected cb func OnKeyInput(event: ref<KeyInputEvent>) -> Void {
    if !Equals(event.GetAction(), EInputAction.IACT_Press) { return; }
    // Any key press also checks that the tick is still alive.
    this.StartTicking();
    let key: EInputKey = event.GetKey();
    if Equals(key, EInputKey.IK_None) { return; }
    let s: ref<PSSSettings> = this.m_settings;
    let nudge: Bool = Equals(key, s.swingLeftKey) || Equals(key, s.swingRightKey) || Equals(key, s.furtherKey)
        || Equals(key, s.closerKey) || Equals(key, s.leftKey) || Equals(key, s.rightKey);
    // The meter prompt's keys, with the gamepad buttons the game shows for the same choices.
    let use: Bool = Equals(key, s.useKey) || Equals(key, EInputKey.IK_Pad_X_SQUARE);
    let choose: Bool = Equals(key, s.chooseKey) || Equals(key, EInputKey.IK_Pad_Y_TRIANGLE);
    if !Equals(key, s.placeKey) && !Equals(key, s.facingKey) && !Equals(key, s.clearKey) && !Equals(key, s.lockKey)
        && !(nudge && this.IsPlacing()) && !((use || choose) && IsDefined(this.m_hubSpot)) { return; }
    let game: GameInstance = this.GetGameInstance();
    if this.IsInMenu(game) { return; }
    let player: ref<PlayerPuppet> = GetPlayer(game);
    if !IsDefined(player) { return; }

    if (use || choose) && IsDefined(this.m_hubSpot) && this.IsHubUp(game) {
      let spot: ref<PSSSpot> = this.m_hubSpot;
      let nearby: ref<VehicleObject> = this.m_hubVehicle;
      if IsDefined(nearby) {
        if use { this.PutAway(game, nearby, spot); }
      } else if !this.m_hubBlocked {
        if use { this.BringOut(game, spot); } else { this.ChooseVehicle(player, spot); }
      }
      this.UpdateHub();
    }

    if Equals(key, s.placeKey) { this.AdvancePlacing(game); }
    if Equals(key, s.facingKey) {
      this.m_facing = IntEnum<PSSFacing>((EnumInt(this.m_facing) + 1) % 4);
      this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-Facing-" + ToString(this.m_facing)));
    }
    if Equals(key, s.clearKey) {
      if this.IsPlacing() {
        this.SetStage(PSSStage.Idle);
        this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-PlacingStopped"));
      } else {
        this.RemoveNearestSpot(game, player);
      }
    }
    if Equals(key, s.lockKey) { this.ToggleLock(game, player); }
    if nudge && this.IsPlacing() {
      if Equals(key, s.swingLeftKey) { this.m_swing -= 15.0; }
      if Equals(key, s.swingRightKey) { this.m_swing += 15.0; }
      if Equals(key, s.furtherKey) { this.m_gap = ClampF(this.m_gap + 0.25, 0.0, 15.0); }
      if Equals(key, s.closerKey) { this.m_gap = ClampF(this.m_gap - 0.25, 0.0, 15.0); }
      if Equals(key, s.leftKey) { this.m_side = ClampF(this.m_side - 0.25, -10.0, 10.0); }
      if Equals(key, s.rightKey) { this.m_side = ClampF(this.m_side + 0.25, -10.0, 10.0); }
    }
  }

  // Not while a menu or photo mode is up, so typing in a menu places nothing.
  private func IsInMenu(game: GameInstance) -> Bool {
    let defs: ref<AllBlackboardDefinitions> = GetAllBlackboardDefs();
    let boards: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(game);
    let ui: ref<IBlackboard> = boards.Get(defs.UI_System);
    if IsDefined(ui) && ui.GetBool(defs.UI_System.IsInMenu) { return true; }
    let photo: ref<IBlackboard> = boards.Get(defs.PhotoMode);
    return IsDefined(photo) && photo.GetBool(defs.PhotoMode.IsActive);
  }

  // ---- Placing a spot ----

  private func AdvancePlacing(game: GameInstance) -> Void {
    // Without a preview there is nothing to line up by eye, so one press does it all.
    if !PSSBridge.HasPreview(false) {
      if this.UpdatePreview() { this.SaveSpot(game); } else { this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-NoSpot")); }
      return;
    }
    switch this.m_stage {
      case PSSStage.Idle:
        this.SetStage(PSSStage.Meter);
        this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-PlacingMeter"));
        break;
      case PSSStage.Meter:
        if this.UpdatePreview() {
          this.SetStage(PSSStage.Vehicle);
          this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-PlacingVehicle"));
        } else {
          this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-NoSpot"));
        }
        break;
      case PSSStage.Vehicle:
        this.UpdatePreview();
        this.SaveSpot(game);
        this.SetStage(PSSStage.Idle);
        break;
    }
  }

  private func SetStage(stage: PSSStage) -> Void {
    let wasPlacing: Bool = this.IsPlacing();
    this.m_stage = stage;
    if NotEquals(wasPlacing, this.IsPlacing()) { PSSBridge.PlacementChanged(this.IsPlacing()); }
  }

  public func IsPlacing() -> Bool {
    return !Equals(this.m_stage, PSSStage.Idle);
  }

  // Works out where the meter and the vehicle go. Until the meter is set it follows
  // the crosshair and faces the player; after that only the vehicle's part changes.
  // False when the player is not looking at ground within reach.
  public func UpdatePreview() -> Bool {
    let game: GameInstance = this.GetGameInstance();
    let player: ref<PlayerPuppet> = GetPlayer(game);
    if !IsDefined(player) { return false; }
    if !Equals(this.m_stage, PSSStage.Vehicle) {
      let meter: Vector4;
      if !this.FindSpot(game, player, meter) { return false; }
      // Flat unit vector from the meter back to the player.
      let toPlayer: Vector4 = player.GetWorldPosition() - meter;
      // Looking straight down gives no direction to work from.
      if Vector4.Length2D(toPlayer) < 0.1 { toPlayer = -player.GetWorldForward(); }
      let length: Float = SqrtF(toPlayer.X * toPlayer.X + toPlayer.Y * toPlayer.Y);
      this.m_meter = meter;
      this.m_front = new Vector4(toPlayer.X / length, toPlayer.Y / length, 0.0, 0.0);
    }

    // The line from the meter out to the vehicle: straight on past the meter from where
    // the player stood when setting it down, swung around the meter. The swing and
    // right are as seen by someone standing at the meter and looking at the vehicle,
    // which is how the player sees them while placing.
    let swing: Float = Deg2Rad(-this.m_swing);
    let outward: Vector4 = new Vector4(-this.m_front.X * CosF(swing) + this.m_front.Y * SinF(swing),
        -this.m_front.X * SinF(swing) - this.m_front.Y * CosF(swing), 0.0, 0.0);
    let right: Vector4 = new Vector4(outward.Y, -outward.X, 0.0, 0.0);

    let heading: Vector4 = -outward;
    let reach: Float = PSSSystem.HalfLength();
    switch this.m_facing {
      case PSSFacing.AwayFromMeter: heading = outward; break;
      case PSSFacing.SideLeft: heading = -right; reach = PSSSystem.HalfWidth(); break;
      case PSSFacing.SideRight: heading = right; reach = PSSSystem.HalfWidth(); break;
    }

    let centre: Vector4 = this.m_meter + outward * (this.m_gap + reach) + right * this.m_side;
    centre.Z = this.FindGround(game, centre);
    centre.W = 1.0;

    let nose: Vector4 = heading * PSSSystem.HalfLength();
    let flank: Vector4 = new Vector4(heading.Y, -heading.X, 0.0, 0.0) * PSSSystem.HalfWidth();
    this.m_points = [this.m_meter, centre, centre + nose - flank, centre + nose + flank, centre - nose + flank, centre - nose - flank];
    // The rotation goes into a variable before its yaw is read: read straight off the
    // call, the yaw comes back as zero.
    let vehicleRotation: EulerAngles = Vector4.ToRotation(heading);
    this.m_yaw = vehicleRotation.Yaw;
    return true;
  }

  // How many points the layout has: the six below.
  public func GetPreviewPointCount() -> Int32 {
    return ArraySize(this.m_points);
  }

  // 0 is the meter, 1 the vehicle's centre, 2 to 5 its corners: front left, front
  // right, rear right, rear left.
  public func GetPreviewPoint(index: Int32) -> Vector4 {
    if index < 0 || index >= ArraySize(this.m_points) { return new Vector4(0.0, 0.0, 0.0, 1.0); }
    return this.m_points[index];
  }

  // Stand-in size for every vehicle until the real one is measured.
  private static func HalfLength() -> Float { return 2.4; }
  private static func HalfWidth() -> Float { return 1.0; }

  // The ground under the crosshair, up to 30 metres away.
  private func FindSpot(game: GameInstance, player: ref<PlayerPuppet>, out spot: Vector4) -> Bool {
    let origin: Vector4;
    let forward: Vector4;
    GameInstance.GetTargetingSystem(game).GetCrosshairData(player, origin, forward);
    let trace: TraceResult;
    if !this.Raycast(game, origin, origin + forward * 30.0, trace) { return false; }
    spot = Vector4.Vector3To4(trace.position);
    return true;
  }

  // Ground height under a point that may be a kerb's height above or below the meter.
  private func FindGround(game: GameInstance, point: Vector4) -> Float {
    let trace: TraceResult;
    let top: Vector4 = new Vector4(point.X, point.Y, point.Z + 2.0, 1.0);
    let bottom: Vector4 = new Vector4(point.X, point.Y, point.Z - 3.0, 1.0);
    if !this.Raycast(game, top, bottom, trace) { return point.Z; }
    return trace.position.Z;
  }

  private func Raycast(game: GameInstance, from: Vector4, to: Vector4, out trace: TraceResult) -> Bool {
    let queries: ref<SpatialQueriesSystem> = GameInstance.GetSpatialQueriesSystem(game);
    return queries.SyncRaycastByCollisionGroup(from, to, n"Static", trace, true, false)
        || queries.SyncRaycastByCollisionGroup(from, to, n"Terrain", trace, false, false);
  }

  // ---- Spots ----

  // Keeps the layout last worked out as a spot. No vehicle comes out until the meter is used.
  private func SaveSpot(game: GameInstance) -> Void {
    let spot: ref<PSSSpot> = new PSSSpot();
    this.m_nextSpotID += 1;
    spot.id = this.m_nextSpotID;
    spot.meter = this.m_points[0];
    spot.position = this.m_points[1];
    spot.yaw = this.m_yaw;
    // Each new spot starts on the first owned vehicle no other spot is set to.
    for vehicle in this.GetOwnedVehicles(game) {
      if !TDBID.IsValid(spot.vehicle) && !this.IsVehicleOfASpot(vehicle.recordID) { spot.vehicle = vehicle.recordID; }
    }
    ArrayPush(this.m_spots, spot);
    PSSBridge.SpotPlaced(spot.id);
    this.Log("spot " + ToString(spot.id) + ": meter at " + ToString(spot.meter)
        + ", vehicle at " + ToString(spot.position) + " turned " + FloatToStringPrec(spot.yaw, 1) + ", facing "
        + ToString(this.m_facing) + ", swing " + FloatToStringPrec(this.m_swing, 0) + ", gap " + FloatToStringPrec(this.m_gap, 2) + ", side " + FloatToStringPrec(this.m_side, 2));

    this.StartTicking();
    this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-SpotSaved"));
  }

  // For the Lua part, which marks each spot when it is saved and after a load.
  public func GetSpotCount() -> Int32 {
    return ArraySize(this.m_spots);
  }

  public func GetSpotID(index: Int32) -> Int32 {
    return this.m_spots[index].id;
  }

  // Whether the mod's own archive, with the word PARKING in it, is installed.
  private static func HasOwnMarking() -> Bool {
    return GameInstance.GetResourceDepot().ResourceExists(r"oitenk\\parking_spot_spawner\\decals\\parking_word.mi");
  }

  // For the Lua part, which paints the ground marking: its material.
  public func GetMarkingMaterial() -> String {
    return "oitenk\\parking_spot_spawner\\decals\\parking_word.mi";
  }

  // The marking's size in metres: the word's width, the height of its letters, and the
  // depth within which it is laid on whatever ground is there.
  public func GetMarkingSize() -> Vector4 {
    return new Vector4(this.m_settings.markingWidth / 100.0, this.m_settings.markingHeight / 100.0, 0.3, 0.0);
  }

  // The Lua part reports each marking it paints, for the debug log.
  public func NoteMarking(material: String, loaded: Bool) -> Void {
    this.Log("marking: decal added with " + material + ", material " + (loaded ? "loaded" : "NOT loaded"));
  }

  // The level way from where a spot's vehicle stands to its meter: straight ahead of
  // the vehicle, behind it or to one side, whichever the meter lies most nearly along.
  private func TowardMeter(spot: ref<PSSSpot>) -> Vector4 {
    let forward: Vector4 = Quaternion.GetForward(EulerAngles.ToQuat(PSSSystem.Heading(spot.yaw)));
    let heading: Vector4 = new Vector4(forward.X, forward.Y, 0.0, 0.0);
    let side: Vector4 = new Vector4(heading.Y, -heading.X, 0.0, 0.0);
    let along: Float = (spot.meter.X - spot.position.X) * heading.X + (spot.meter.Y - spot.position.Y) * heading.Y;
    let across: Float = (spot.meter.X - spot.position.X) * side.X + (spot.meter.Y - spot.position.Y) * side.Y;
    if AbsF(along) >= AbsF(across) { return along < 0.0 ? -heading : heading; }
    return across < 0.0 ? -side : side;
  }

  // For the Lua part: where the middle of a saved spot's ground marking lies, and how it
  // is turned. The word is the spot's meter: it lies where the meter was set down, and
  // reads upright to someone standing at it with the vehicle's place beyond it, the
  // way the player stood when placing the spot.
  public func GetSpotMarking(index: Int32) -> Vector4 {
    let place: Vector4 = this.m_spots[index].meter;
    place.W = 1.0;
    return place;
  }

  public func GetSpotMarkingYaw(index: Int32) -> Float {
    let rotation: EulerAngles = Vector4.ToRotation(-this.TowardMeter(this.m_spots[index]));
    return rotation.Yaw;
  }

  // What the marking depends on, as "shown;width;height". It is not shown when the
  // archive with its texture is missing. The Lua part paints the markings afresh when any
  // of this changes.
  public func GetMarkingStyle() -> String {
    let s: ref<PSSSettings> = this.m_settings;
    return (s.marking && PSSSystem.HasOwnMarking() ? "1" : "0") + ";" + FloatToStringPrec(s.markingWidth, 0)
        + ";" + FloatToStringPrec(s.markingHeight, 0);
  }

  // The spot whose meter is nearest the player, within five metres.
  private func FindNearestSpot(player: ref<PlayerPuppet>) -> ref<PSSSpot> {
    let nearest: ref<PSSSpot>;
    let nearestDistance: Float = 5.0;
    for spot in this.m_spots {
      let distance: Float = Vector4.Distance2D(player.GetWorldPosition(), spot.meter);
      if distance < nearestDistance {
        nearest = spot;
        nearestDistance = distance;
      }
    }
    return nearest;
  }

  // Takes a spot away, with whatever the mod was doing for it.
  private func RemoveSpot(spot: ref<PSSSpot>) -> Void {
    // A copy the mod spawned for the spot goes with it; the game's own vehicles stay.
    if this.IsOwnCopy(spot.parked) { GameInstance.GetDynamicEntitySystem().DeleteEntity(spot.parked); }
    if this.m_bringSpot == spot { this.StopBringingOut(); }
    if this.m_chooseSpot == spot { this.m_chooseSpot = null; }
    ArrayRemove(this.m_spots, spot);
    PSSBridge.SpotRemoved(spot.id);
  }

  private func RemoveNearestSpot(game: GameInstance, player: ref<PlayerPuppet>) -> Void {
    let nearest: ref<PSSSpot> = this.FindNearestSpot(player);
    if !IsDefined(nearest) {
      this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-NoSpotNearby"));
      return;
    }
    if nearest.locked {
      this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-SpotIsLocked"));
      return;
    }
    this.RemoveSpot(nearest);
    this.UpdateHub();
    this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-SpotRemoved"));
  }

  // Locks or unlocks the spot whose prompt is up, or else the nearest one.
  private func ToggleLock(game: GameInstance, player: ref<PlayerPuppet>) -> Void {
    let spot: ref<PSSSpot> = IsDefined(this.m_hubSpot) ? this.m_hubSpot : this.FindNearestSpot(player);
    if !IsDefined(spot) {
      this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-NoSpotNearby"));
      return;
    }
    spot.locked = !spot.locked;
    this.UpdateHub();
    this.ShowMessage(game, PSS_Text(spot.locked ? "ParkingSpotSpawner-SpotLocked" : "ParkingSpotSpawner-SpotUnlocked"));
  }

  // Carries out a "remove all" that was switched on in Mod Settings, which has no
  // buttons: a switch that goes from off to on while a save is being played removes
  // the spots once, and is then turned back off. The first look only notes how the
  // switches stand, so one left on from the main menu or an earlier session does nothing.
  private func UpdateRemoveSwitches(game: GameInstance) -> Void {
    let s: ref<PSSSettings> = this.m_settings;
    let unlocked: Bool = this.m_switchesSeen && s.removeUnlocked && !this.m_removeUnlockedWas;
    let everything: Bool = this.m_switchesSeen && s.removeEverything && !this.m_removeEverythingWas;
    this.m_switchesSeen = true;
    this.m_removeUnlockedWas = s.removeUnlocked;
    this.m_removeEverythingWas = s.removeEverything;
    if !s.removeUnlocked && !s.removeEverything {
      this.m_switchResetTried = false;
      return;
    }
    if !this.m_switchResetTried {
      this.m_switchResetTried = true;
      PSS_ResetRemoveSwitches();
    }
    if everything || unlocked { this.RemoveAllSpots(game, everything); }
  }

  // Removes every spot in the save: the unlocked ones, or the locked ones as well.
  private func RemoveAllSpots(game: GameInstance, lockedToo: Bool) -> Void {
    let doomed: array<ref<PSSSpot>>;
    for spot in this.m_spots {
      if lockedToo || !spot.locked { ArrayPush(doomed, spot); }
    }
    let count: Int32 = ArraySize(doomed);
    let kept: Int32 = ArraySize(this.m_spots) - count;
    if count == 0 {
      this.ShowMessage(game, PSS_Text(kept > 0 ? "ParkingSpotSpawner-AllLocked" : "ParkingSpotSpawner-NoSpots"));
      return;
    }
    for spot in doomed {
      this.RemoveSpot(spot);
    }
    this.UpdateHub();
    let done: String = PSS_Text(kept > 0 ? "ParkingSpotSpawner-RemovedAllKept" : "ParkingSpotSpawner-RemovedAll");
    this.ShowMessage(game, StrReplace(StrReplace(done, "{COUNT}", ToString(count)), "{KEPT}", ToString(kept)));
    this.Log("removed " + ToString(count) + " spots at once, " + ToString(kept) + " locked ones kept");
  }

  private func IsVehicleOfASpot(vehicle: TweakDBID) -> Bool {
    for spot in this.m_spots {
      if Equals(spot.vehicle, vehicle) { return true; }
    }
    return false;
  }

  private func GetOwnedVehicles(game: GameInstance) -> array<PlayerVehicle> {
    let vehicles: array<PlayerVehicle>;
    GameInstance.GetVehicleSystem(game).GetPlayerUnlockedVehicles(vehicles);
    return vehicles;
  }

  private func GetVehicleName(vehicle: TweakDBID) -> String {
    let record: ref<Vehicle_Record> = TweakDBInterface.GetVehicleRecord(vehicle);
    if !IsDefined(record) { return ""; }
    return GetLocalizedTextByKey(record.DisplayName());
  }

  // True for a vehicle the mod spawned itself, as opposed to one the game delivered.
  private func IsOwnCopy(vehicle: EntityID) -> Bool {
    return EntityID.IsDefined(vehicle) && GameInstance.GetDynamicEntitySystem().IsTagged(vehicle, n"ParkingSpotSpawner");
  }

  private func BringOut(game: GameInstance, spot: ref<PSSSpot>) -> Void {
    // One at a time: the last request is still being carried out.
    if this.m_bringStage != 0 { return; }
    let vehicles: array<PlayerVehicle> = this.GetOwnedVehicles(game);
    let chosen: PlayerVehicle;
    let found: Bool = false;
    for vehicle in vehicles {
      if Equals(vehicle.recordID, spot.vehicle) {
        chosen = vehicle;
        found = true;
      }
    }
    // The spot's vehicle may have been sold or taken away since it was chosen.
    if !found {
      if ArraySize(vehicles) == 0 {
        this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-NoVehicles"));
        return;
      }
      chosen = vehicles[0];
      spot.vehicle = chosen.recordID;
    }
    this.Log("spot " + ToString(spot.id) + ": bringing out " + TDBID.ToStringDEBUG(spot.vehicle));

    if this.m_settings.ownVehicles {
      // Already out somewhere the mod knows of: that one is moved here, and nothing is called.
      let existing: ref<VehicleObject> = this.FindKnownVehicle(game, chosen.recordID);
      if IsDefined(existing) && !existing.IsPlayerMounted() {
        this.Log("spot " + ToString(spot.id) + ": moving the one already out, entity " + ToString(EntityID.GetHash(existing.GetEntityID())));
        this.ForgetParked(existing.GetEntityID());
        spot.parked = existing.GetEntityID();
        this.StandOnSpot(existing, spot);
        return;
      }
      // With the summon mode switched the game puts the vehicle down near the player
      // and does not drive it over. Any copy it still has in the world goes first.
      let vehicleSystem: ref<VehicleSystem> = GameInstance.GetVehicleSystem(game);
      let none: EntityID;
      let garageID: GarageVehicleID;
      garageID.recordID = chosen.recordID;
      this.m_bringOldID = none;
      this.m_bringSpot = spot;
      this.m_bringVehicle = chosen;
      this.m_bringStage = 1;
      this.m_bringTicks = 0;
      vehicleSystem.ToggleSummonMode();
      this.m_summonModeSwitched = true;
      vehicleSystem.DespawnPlayerVehicle(garageID);
      return;
    }

    // Left out of the save, so a copy is gone after a reload.
    if this.IsOwnCopy(spot.parked) { GameInstance.GetDynamicEntitySystem().DeleteEntity(spot.parked); }
    let spec: ref<DynamicEntitySpec> = new DynamicEntitySpec();
    spec.recordID = spot.vehicle;
    spec.position = spot.position;
    spec.orientation = EulerAngles.ToQuat(PSSSystem.Heading(spot.yaw));
    spec.tags = [n"ParkingSpotSpawner"];
    spot.parked = GameInstance.GetDynamicEntitySystem().CreateEntity(spec);
  }

  // Runs from the tick while one of the game's own vehicles is being brought out.
  private func UpdateBringingOut(game: GameInstance) -> Void {
    if this.m_bringStage == 0 { return; }
    this.m_bringTicks += 1;
    let spot: ref<PSSSpot> = this.m_bringSpot;

    if this.m_bringStage == 1 {
      // Give the old copy a moment to go, and up to four seconds if it lingers.
      if this.m_bringTicks < 3 { return; }
      if EntityID.IsDefined(this.m_bringOldID) && IsDefined(GameInstance.FindEntityByID(game, this.m_bringOldID)) {
        if this.m_bringTicks >= 20 { this.FailBringingOut(game); }
        return;
      }
      // The call's own result is not a dependable sign of success, so the vehicle
      // is looked for afterwards instead.
      GameInstance.GetVehicleSystem(game).SpawnPlayerVehicle(this.m_bringVehicle.vehicleType, this.m_bringVehicle.recordID, false);
      this.RestoreSummonMode();
      this.m_bringStage = 2;
      this.m_bringTicks = 0;
      return;
    }

    let vehicle: ref<VehicleObject> = this.GetSummonedVehicle(game);
    let arrived: Bool = IsDefined(vehicle) && Equals(vehicle.GetRecordID(), this.m_bringVehicle.recordID)
        && !Equals(vehicle.GetEntityID(), this.m_bringOldID);

    if this.m_bringStage == 2 {
      if this.m_bringTicks < 2 { return; }
      if !arrived {
        if this.m_bringTicks >= 40 { this.FailBringingOut(game); }
        return;
      }
      this.Log("spot " + ToString(spot.id) + ": the game delivered " + TDBID.ToStringDEBUG(vehicle.GetRecordID()) + ", entity " + ToString(EntityID.GetHash(vehicle.GetEntityID()))
          + ", IsPlayerVehicle " + ToString(vehicle.IsPlayerVehicle()));
      spot.parked = vehicle.GetEntityID();
      this.StandOnSpot(vehicle, spot);
      this.m_bringStage = 3;
      this.m_bringTicks = 0;
      return;
    }

    // For a second after it lands, put the vehicle back if it has rolled off the spot.
    if arrived && !vehicle.IsPlayerMounted() && Vector4.Distance2D(vehicle.GetWorldPosition(), spot.position) > 0.75 {
      this.StandOnSpot(vehicle, spot);
    }
    if !arrived || this.m_bringTicks >= 5 { this.StopBringingOut(); }
  }

  private func ForgetParked(vehicle: EntityID) -> Void {
    let none: EntityID;
    for spot in this.m_spots {
      if Equals(spot.parked, vehicle) { spot.parked = none; }
    }
  }

  private func StandOnSpot(vehicle: ref<VehicleObject>, spot: ref<PSSSpot>) -> Void {
    GameInstance.GetTeleportationFacility(vehicle.GetGame()).Teleport(vehicle, spot.position, PSSSystem.Heading(spot.yaw));
    vehicle.ForceBrakesFor(1.0);
  }

  // A level rotation turned to the given yaw.
  private static func Heading(yaw: Float) -> EulerAngles {
    let rotation: EulerAngles;
    rotation.Yaw = yaw;
    return rotation;
  }

  private func FailBringingOut(game: GameInstance) -> Void {
    this.Log("bringing out " + TDBID.ToStringDEBUG(this.m_bringVehicle.recordID) + " failed at step " + ToString(this.m_bringStage));
    this.StopBringingOut();
    this.ShowMessage(game, PSS_Text("ParkingSpotSpawner-CantBringOut"));
  }

  private func StopBringingOut() -> Void {
    this.RestoreSummonMode();
    this.m_bringStage = 0;
    this.m_bringSpot = null;
  }

  // Puts the game's summon mode back the way it was found.
  private func RestoreSummonMode() -> Void {
    if !this.m_summonModeSwitched { return; }
    this.m_summonModeSwitched = false;
    GameInstance.GetVehicleSystem(this.GetGameInstance()).ToggleSummonMode();
  }

  // The vehicle the game last delivered to the player, if it is still in the world.
  private func GetSummonedVehicle(game: GameInstance) -> ref<VehicleObject> {
    let summon: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().VehicleSummonData);
    let id: EntityID = summon.GetEntityID(GetAllBlackboardDefs().VehicleSummonData.SummonedVehicleEntityID);
    if !EntityID.IsDefined(id) { return null; }
    return GameInstance.FindEntityByID(game, id) as VehicleObject;
  }

  // Owned vehicles in the world that are not tied to a spot: the one the player last
  // rode in and the one the game last delivered.
  private func GetLooseVehicles(game: GameInstance) -> array<ref<VehicleObject>> {
    let loose: array<ref<VehicleObject>>;
    ArrayPush(loose, this.m_lastVehicle);
    ArrayPush(loose, this.GetSummonedVehicle(game));
    return loose;
  }

  // An owned vehicle of this kind that is out in the world: a loose one, one a meter
  // brought out this session, or one standing on any spot.
  private func FindKnownVehicle(game: GameInstance, record: TweakDBID) -> ref<VehicleObject> {
    let known: array<ref<VehicleObject>> = this.GetLooseVehicles(game);
    for spot in this.m_spots {
      if EntityID.IsDefined(spot.parked) { ArrayPush(known, GameInstance.FindEntityByID(game, spot.parked) as VehicleObject); }
      ArrayPush(known, this.FindVehicleOnSpot(game, spot));
    }
    for vehicle in known {
      if IsDefined(vehicle) && this.IsOurs(vehicle) && Equals(vehicle.GetRecordID(), record) { return vehicle; }
    }
    return null;
  }

  // Sends a vehicle away and leaves the spot set to bring that one out next time.
  private func PutAway(game: GameInstance, vehicle: ref<VehicleObject>, spot: ref<PSSSpot>) -> Void {
    let id: EntityID = vehicle.GetEntityID();
    let record: TweakDBID = vehicle.GetRecordID();
    this.Log("spot " + ToString(spot.id) + ": putting away " + TDBID.ToStringDEBUG(record) + ", entity " + ToString(EntityID.GetHash(id)));
    if this.IsOwnCopy(id) {
      GameInstance.GetDynamicEntitySystem().DeleteEntity(id);
    } else {
      let garageID: GarageVehicleID;
      garageID.recordID = record;
      GameInstance.GetVehicleSystem(game).DespawnPlayerVehicle(garageID);
    }
    spot.vehicle = record;
    this.ForgetParked(id);
    if this.m_lastVehicle == vehicle { this.m_lastVehicle = null; }
  }

  // An owned vehicle this meter can put away: the one standing on its spot, or failing
  // that one the player left within eight metres, provided no other spot is nearer to
  // it. Without that last rule, meters set side by side would take each other's vehicles.
  private func FindVehicleBySpot(game: GameInstance, spot: ref<PSSSpot>, standing: ref<VehicleObject>) -> ref<VehicleObject> {
    if IsDefined(standing) && !standing.IsPlayerMounted() && this.IsOurs(standing) { return standing; }
    let candidates: array<ref<VehicleObject>> = this.GetLooseVehicles(game);
    if EntityID.IsDefined(spot.parked) { ArrayPush(candidates, GameInstance.FindEntityByID(game, spot.parked) as VehicleObject); }
    let found: ref<VehicleObject>;
    let foundDistance: Float = 8.0;
    for vehicle in candidates {
      if IsDefined(vehicle) && !vehicle.IsPlayerMounted() && this.IsOurs(vehicle) {
        let distance: Float = Vector4.Distance2D(vehicle.GetWorldPosition(), spot.position);
        if distance < foundDistance && this.IsNearestSpot(spot, vehicle.GetWorldPosition(), distance) {
          found = vehicle;
          foundDistance = distance;
        }
      }
    }
    return found;
  }

  // True when no other spot is nearer to the position than this one is.
  private func IsNearestSpot(spot: ref<PSSSpot>, position: Vector4, distance: Float) -> Bool {
    for other in this.m_spots {
      if other != spot && Vector4.Distance2D(position, other.position) < distance { return false; }
    }
    return true;
  }

  // The player's own: one the game counts as theirs, or a copy the mod spawned.
  private func IsOurs(vehicle: ref<VehicleObject>) -> Bool {
    return vehicle.IsPlayerVehicle() || this.IsOwnCopy(vehicle.GetEntityID());
  }

  // Whatever vehicle is standing on the spot, found by probing down through the middle
  // of it and through its ends and sides. This sees vehicles the mod has no record
  // of, such as one that came back with a loaded save or one that is not the player's.
  private func FindVehicleOnSpot(game: GameInstance, spot: ref<PSSSpot>) -> ref<VehicleObject> {
    let forward: Vector4 = Quaternion.GetForward(EulerAngles.ToQuat(PSSSystem.Heading(spot.yaw)));
    let along: Vector4 = new Vector4(forward.X, forward.Y, 0.0, 0.0) * 1.4;
    let across: Vector4 = new Vector4(forward.Y, -forward.X, 0.0, 0.0) * 0.6;
    let probes: array<Vector4> = [spot.position, spot.position + along, spot.position - along, spot.position + across, spot.position - across];
    let queries: ref<SpatialQueriesSystem> = GameInstance.GetSpatialQueriesSystem(game);
    for probe in probes {
      let top: Vector4 = new Vector4(probe.X, probe.Y, probe.Z + 3.0, 1.0);
      let bottom: Vector4 = new Vector4(probe.X, probe.Y, probe.Z + 0.2, 1.0);
      let trace: TraceResult;
      if queries.SyncRaycastByCollisionGroup(top, bottom, n"Vehicle", trace, false, false) {
        let vehicle: ref<VehicleObject> = TraceResult.GetHitEntity(trace) as VehicleObject;
        if IsDefined(vehicle) { return vehicle; }
      }
    }
    return null;
  }

  public static func Get(game: GameInstance) -> ref<PSSSystem> {
    return GameInstance.GetScriptableSystemsContainer(game).Get(n"ParkingSpotSpawner.PSSSystem") as PSSSystem;
  }

  // Opens the game's own vehicle list for the spot. What is confirmed in it comes
  // back through OnVehicleChosen instead of being called the usual way.
  private func ChooseVehicle(player: ref<PlayerPuppet>, spot: ref<PSSSpot>) -> Void {
    if this.m_bringStage != 0 || this.IsChoosingVehicle() { return; }
    this.m_chooseSpot = spot;
    this.m_chooseTicks = 0;
    this.m_chooseOpened = false;
    this.m_chosen = false;
    let request: ref<QuickSlotButtonHoldStartEvent> = new QuickSlotButtonHoldStartEvent();
    request.dPadItemDirection = EDPadSlot.VehicleWheel;
    player.QueueEvent(request);
  }

  public func IsChoosingVehicle() -> Bool {
    return IsDefined(this.m_chooseSpot);
  }

  // The vehicle list confirmed a vehicle while open for a meter: the spot takes it
  // and brings it out. False for any further confirm from the same list.
  public func OnVehicleChosen(vehicle: PlayerVehicle) -> Bool {
    if this.m_chosen || !IsDefined(this.m_chooseSpot) { return false; }
    this.m_chosen = true;
    this.m_chooseSpot.vehicle = vehicle.recordID;
    this.BringOut(this.GetGameInstance(), this.m_chooseSpot);
    return true;
  }

  // Stops waiting on the vehicle list once it has closed, or if it never came up.
  private func UpdateChoosing(game: GameInstance) -> Void {
    if !this.IsChoosingVehicle() { return; }
    this.m_chooseTicks += 1;
    let shown: Bool = GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().UIGameData).GetBool(GetAllBlackboardDefs().UIGameData.Popup_VehiclesManager_IsShown);
    if shown {
      this.m_chooseOpened = true;
    } else if this.m_chooseOpened || this.m_chooseTicks > 5 {
      this.m_chooseSpot = null;
    }
  }

  // Moves the spot on to the vehicle after its current one in the owned list.
  private func SelectNextVehicle(game: GameInstance, spot: ref<PSSSpot>) -> Void {
    let vehicles: array<PlayerVehicle> = this.GetOwnedVehicles(game);
    let count: Int32 = ArraySize(vehicles);
    if count == 0 { return; }
    let current: Int32 = -1;
    let i: Int32 = 0;
    while i < count {
      if Equals(vehicles[i].recordID, spot.vehicle) { current = i; }
      i += 1;
    }
    spot.vehicle = vehicles[(current + 1) % count].recordID;
  }

  protected cb func OnParkedVehicleEvent(event: ref<DynamicEntityEvent>) -> Void {
    if !Equals(event.GetEventType(), DynamicEntityEventType.Spawned) { return; }
    let vehicle: ref<VehicleObject> = GameInstance.GetDynamicEntitySystem().GetEntity(event.GetEntityID()) as VehicleObject;
    if !IsDefined(vehicle) { return; }
    let ps: ref<VehicleComponentPS> = vehicle.GetVehiclePS();
    if !IsDefined(ps) { return; }

    // The game does not count a copy as the player's, so it is marked and unlocked by hand.
    this.Log("spawned a copy of " + TDBID.ToStringDEBUG(vehicle.GetRecordID()) + ", driver door " + ToString(ps.GetDoorInteractionState(EVehicleDoor.seat_front_left)));
    ps.SetIsPlayerVehicle(true);
    ps.SetDoorInteractionState(EVehicleDoor.seat_front_left, VehicleDoorInteractionState.Available, "ParkingSpotSpawner");
    ps.SetDoorInteractionState(EVehicleDoor.seat_front_right, VehicleDoorInteractionState.Available, "ParkingSpotSpawner");
    ps.SetDoorInteractionState(EVehicleDoor.seat_back_left, VehicleDoorInteractionState.Available, "ParkingSpotSpawner");
    ps.SetDoorInteractionState(EVehicleDoor.seat_back_right, VehicleDoorInteractionState.Available, "ParkingSpotSpawner");
  }

  // ---- The prompt on a meter ----

  // Starts the tick, or starts it again if the last one is overdue: a tick scheduled
  // while a save is still loading can be lost, which would leave every meter dead.
  private func StartTicking() -> Void {
    if ArraySize(this.m_spots) == 0 { return; }
    let now: Float = this.Now();
    if this.m_ticking && now - this.m_tickTime < 3.0 { return; }
    if this.m_ticking { this.Log("the tick had stopped; starting it again"); }
    this.m_ticking = true;
    this.m_tickGeneration += 1;
    this.m_tickTime = now;
    this.ScheduleTick();
  }

  private func Now() -> Float {
    return EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGameInstance()));
  }

  private func ScheduleTick() -> Void {
    let callback: ref<PSSTickCallback> = new PSSTickCallback();
    callback.m_system = this;
    callback.m_generation = this.m_tickGeneration;
    GameInstance.GetDelaySystem(this.GetGameInstance()).DelayCallback(callback, 0.2, false);
  }

  // Runs five times a second while there are spots: keeps track of the player's
  // vehicle, carries on bringing one out, and puts the prompt up or takes it down.
  public func OnTick(generation: Int32) -> Void {
    if generation != this.m_tickGeneration { return; }
    let game: GameInstance = this.GetGameInstance();
    let player: ref<PlayerPuppet> = GetPlayer(game);
    this.m_tickTime = this.Now();
    if IsDefined(player) {
      let mounted: ref<VehicleObject> = GetMountedVehicle(player);
      if IsDefined(mounted) { this.m_lastVehicle = mounted; }
      this.LogGarage(game, player);
    }
    this.UpdateBringingOut(game);
    this.UpdateChoosing(game);
    this.UpdateRemoveSwitches(game);
    this.UpdateHub();
    if ArraySize(this.m_spots) == 0 {
      this.m_ticking = false;
      return;
    }
    this.ScheduleTick();
  }

  // Debug: what the game's garage has on record and what stands on each spot, logged
  // whenever any of it changes.
  private func LogGarage(game: GameInstance, player: ref<PlayerPuppet>) -> Void {
    if !this.m_settings.debug { return; }
    if !IsDefined(this.m_garage) {
      for component in player.GetComponents() {
        let garage: ref<GarageComponent> = component as GarageComponent;
        if IsDefined(garage) { this.m_garage = garage; }
      }
    }
    let text: String = "no garage component on the player";
    let garage: ref<GarageComponent> = this.m_garage;
    let state: ref<GarageComponentPS> = IsDefined(garage) ? garage.GetPS() as GarageComponentPS : null;
    if IsDefined(state) {
      text = "spawned" + this.DescribeGarageEntries(state.spawnedVehiclesData) + " | unregistered" + this.DescribeGarageEntries(state.unregisteredVehiclesData);
    }
    for spot in this.m_spots {
      let parked: ref<VehicleObject> = EntityID.IsDefined(spot.parked) ? GameInstance.FindEntityByID(game, spot.parked) as VehicleObject : null;
      if IsDefined(parked) {
        text += " | spot " + ToString(spot.id) + ": entity " + ToString(EntityID.GetHash(spot.parked)) + " IsPlayerVehicle " + ToString(parked.IsPlayerVehicle());
      } else {
        text += " | spot " + ToString(spot.id) + ": nothing";
      }
    }
    if !Equals(text, this.m_garageLog) {
      this.m_garageLog = text;
      this.Log("garage: " + text);
    }
  }

  private func DescribeGarageEntries(entries: array<vehicleGarageComponentVehicleData>) -> String {
    let text: String = "";
    for entry in entries {
      text += " [" + TDBID.ToStringDEBUG(entry.spawnRecordID) + ", entity " + ToString(EntityID.GetHash(entry.entityID))
          + (entry.despawnOnDistanceEnabled ? ", goes when far" : ", stays") + "]";
    }
    return Equals(text, "") ? " none" : text;
  }

  private func UpdateHub() -> Void {
    let game: GameInstance = this.GetGameInstance();
    let player: ref<PlayerPuppet> = GetPlayer(game);
    let spot: ref<PSSSpot>;
    if IsDefined(player) && !this.IsPlacing() && !this.IsChoosingVehicle() && !this.IsInMenu(game) && !IsDefined(GetMountedVehicle(player)) {
      spot = this.FindSpotLookedAt(game, player);
    }
    if IsDefined(spot) { this.ShowHub(game, spot); } else { this.HideHub(game); }
  }

  // The nearest spot whose marking is within three and a half metres and close to the
  // crosshair.
  private func FindSpotLookedAt(game: GameInstance, player: ref<PlayerPuppet>) -> ref<PSSSpot> {
    let origin: Vector4;
    let forward: Vector4;
    GameInstance.GetTargetingSystem(game).GetCrosshairData(player, origin, forward);
    let found: ref<PSSSpot>;
    let foundDistance: Float = 3.5;
    for spot in this.m_spots {
      // A look at the word will do, at its middle or toward either end.
      let toward: Vector4 = this.TowardMeter(spot);
      let along: Vector4 = new Vector4(toward.Y, -toward.X, 0.0, 0.0) * (this.m_settings.markingWidth / 300.0);
      let low: Vector4 = spot.meter + new Vector4(0.0, 0.0, 0.1, 0.0);
      let targets: array<Vector4> = [low, low + along, low - along];
      for target in targets {
        let x: Float = target.X - origin.X;
        let y: Float = target.Y - origin.Y;
        let z: Float = target.Z - origin.Z;
        let distance: Float = SqrtF(x * x + y * y + z * z);
        if distance < foundDistance && (x * forward.X + y * forward.Y + z * forward.Z) > 0.9 * distance {
          found = spot;
          foundDistance = distance;
        }
      }
    }
    return found;
  }

  private static func HubID() -> Int32 { return -7701; }

  // Puts the game's own interaction prompt up for the meter: put away the owned
  // vehicle standing on or by the spot, or with the spot clear bring its vehicle out
  // or pick another. A vehicle that is not the player's blocks the spot.
  private func ShowHub(game: GameInstance, spot: ref<PSSSpot>) -> Void {
    let defs: ref<UIInteractionsDef> = GetAllBlackboardDefs().UIInteractions;
    let board: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).Get(defs);
    let current: InteractionChoiceHubData = FromVariant<InteractionChoiceHubData>(board.GetVariant(defs.InteractionChoiceHub));
    // Something of the game's own is on offer; leave it alone.
    if current.active && current.id != PSSSystem.HubID() {
      this.m_hubSpot = null;
      return;
    }

    if !TDBID.IsValid(spot.vehicle) { this.SelectNextVehicle(game, spot); }
    let standing: ref<VehicleObject> = this.FindVehicleOnSpot(game, spot);
    let nearby: ref<VehicleObject> = this.FindVehicleBySpot(game, spot, standing);
    let out: Bool = IsDefined(nearby);
    let blocked: Bool = !out && IsDefined(standing);
    let label: String = PSS_Text("ParkingSpotSpawner-Blocked");
    if out {
      label = StrReplace(PSS_Text("ParkingSpotSpawner-PutAway"), "{NAME}", this.GetVehicleName(nearby.GetRecordID()));
    } else if !blocked {
      label = StrReplace(PSS_Text("ParkingSpotSpawner-BringOut"), "{NAME}", this.GetVehicleName(spot.vehicle));
    }
    let signature: String = ToString(spot.id) + label + (spot.locked ? " locked" : "");
    this.m_hubVehicle = nearby;
    this.m_hubBlocked = blocked;
    if current.active && IsDefined(this.m_hubSpot) && Equals(this.m_hubSignature, signature) { return; }

    let hub: InteractionChoiceHubData;
    hub.id = PSSSystem.HubID();
    hub.active = true;
    hub.title = PSS_Text(spot.locked ? "ParkingSpotSpawner-MeterTitleLocked" : "ParkingSpotSpawner-MeterTitle");
    let use: InteractionChoiceData;
    use.inputAction = n"Choice1";
    use.localizedName = label;
    if blocked { ChoiceTypeWrapper.SetType(use.type, gameinteractionsChoiceType.Inactive); }
    ArrayPush(hub.choices, use);
    if !out && !blocked {
      let next: InteractionChoiceData;
      next.inputAction = n"Choice2";
      next.localizedName = PSS_Text("ParkingSpotSpawner-ChooseVehicle");
      ArrayPush(hub.choices, next);
    }
    let visualizers: VisualizersInfo;
    visualizers.activeVisId = hub.id;
    ArrayPush(visualizers.visIds, hub.id);
    board.SetVariant(defs.InteractionChoiceHub, ToVariant(hub), true);
    board.SetVariant(defs.VisualizersInfo, ToVariant(visualizers), true);
    this.m_hubSpot = spot;
    this.m_hubSignature = signature;
  }

  private func HideHub(game: GameInstance) -> Void {
    if !IsDefined(this.m_hubSpot) { return; }
    this.m_hubSpot = null;
    this.m_hubVehicle = null;
    this.m_hubBlocked = false;
    this.m_hubSignature = "";
    let defs: ref<UIInteractionsDef> = GetAllBlackboardDefs().UIInteractions;
    let board: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).Get(defs);
    let current: InteractionChoiceHubData = FromVariant<InteractionChoiceHubData>(board.GetVariant(defs.InteractionChoiceHub));
    // The game has put up a prompt of its own since; it is not ours to take down.
    if current.id != PSSSystem.HubID() { return; }

    let hub: InteractionChoiceHubData;
    hub.id = PSSSystem.HubID();
    hub.active = false;
    let visualizers: VisualizersInfo;
    visualizers.activeVisId = -1;
    board.SetVariant(defs.InteractionChoiceHub, ToVariant(hub), true);
    board.SetVariant(defs.VisualizersInfo, ToVariant(visualizers), true);
  }

  // False once the game has put a prompt of its own up in place of the meter's.
  private func IsHubUp(game: GameInstance) -> Bool {
    let defs: ref<UIInteractionsDef> = GetAllBlackboardDefs().UIInteractions;
    let board: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).Get(defs);
    let current: InteractionChoiceHubData = FromVariant<InteractionChoiceHubData>(board.GetVariant(defs.InteractionChoiceHub));
    return current.active && current.id == PSSSystem.HubID();
  }

  private func ShowMessage(game: GameInstance, text: String) -> Void {
    let message: SimpleScreenMessage;
    message.isShown = true;
    message.duration = 4.0;
    message.message = text;
    GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().UI_Notifications).SetVariant(GetAllBlackboardDefs().UI_Notifications.OnscreenMessage, ToVariant(message), true);
  }

  private func Log(message: String) -> Void {
    if IsDefined(this.m_settings) && this.m_settings.debug { FTLog("[ParkingSpotSpawner] " + message); }
  }
}

// While the game's vehicle list is open for a meter, confirming a vehicle in it hands
// the choice to the meter and skips the list's own call, which would drive it over.
@wrapMethod(VehiclesManagerPopupGameController)
protected func Activate() -> Void {
  let player: ref<GameObject> = this.m_playerPuppet;
  let system: ref<PSSSystem> = IsDefined(player) ? PSSSystem.Get(player.GetGame()) : null;
  if !IsDefined(system) || !system.IsChoosingVehicle() {
    wrappedMethod();
    return;
  }
  let selected: ref<VehiclesManagerListItemController> = this.m_listController.GetSelectedItem() as VehiclesManagerListItemController;
  if !IsDefined(selected) || IsDefined(this.m_selectAnimProxy) { return; }
  let data: ref<VehicleListItemData> = selected.GetVehicleData();
  // A wrecked vehicle still being repaired cannot be picked, the same as in the list itself.
  if data.m_repairTimeRemaining > 0.0 || !system.OnVehicleChosen(data.m_data) { return; }
  this.m_selectAnimProxy = this.PlayLibraryAnimationOnTargets(n"selected", SelectWidgets(selected.GetRootWidget()));
  this.m_selectAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnSelectAnimFinished");
}

// Text from the mod's localization (ParkingSpotSpawnerLocalization.reds), in the
// language the game is set to.
func PSS_Text(key: String) -> String {
  let text: String = GetLocalizedTextByKey(StringToName(key));
  return Equals(text, "") || Equals(text, key) ? key : text;
}

@if(ModuleExists("ModSettingsModule"))
func PSS_RegisterSettings(settings: ref<PSSSettings>) -> Void {
  ModSettings.RegisterListenerToClass(settings);
}

@if(!ModuleExists("ModSettingsModule"))
func PSS_RegisterSettings(settings: ref<PSSSettings>) -> Void {}

@if(ModuleExists("ModSettingsModule"))
func PSS_UnregisterSettings(settings: ref<PSSSettings>) -> Void {
  ModSettings.UnregisterListenerToClass(settings);
}

@if(!ModuleExists("ModSettingsModule"))
func PSS_UnregisterSettings(settings: ref<PSSSettings>) -> Void {}

// Turns the two "remove all" switches back off in Mod Settings itself.
@if(ModuleExists("ModSettingsModule"))
func PSS_ResetRemoveSwitches() -> Void {
  let mod: CName = n"Parking Spot Spawner";
  let changed: Bool = false;
  for category in ModSettings.GetCategories(mod) {
    for entry in ModSettings.GetVars(mod, category) {
      let toggle: ref<ModConfigVarBool> = entry as ModConfigVarBool;
      if IsDefined(toggle) && toggle.GetValue() && (Equals(entry.GetName(), n"removeUnlocked") || Equals(entry.GetName(), n"removeEverything")) {
        toggle.SetValue(false);
        changed = true;
      }
    }
  }
  if changed { ModSettings.AcceptChanges(); }
}

@if(!ModuleExists("ModSettingsModule"))
func PSS_ResetRemoveSwitches() -> Void {}
