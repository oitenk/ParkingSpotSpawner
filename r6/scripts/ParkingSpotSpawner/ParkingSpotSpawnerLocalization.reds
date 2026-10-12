// Parking Spot Spawner: text shown by the mod, registered with Codeware's localization
// system so it can be translated.
//
// To add a language, copy PSSLanguageEnglish into a new class (in a file of its own),
// translate the second string of every line and leave the first alone, then return
// the new class for that language from PSSLocalizationProvider.GetPackage below.
// {NAME}, {COUNT} and {KEPT} are filled in by the mod, so keep them in. Vehicle names
// come from the game and are already translated.
//
// The Mod Settings page is written in English only.
module ParkingSpotSpawner

import Codeware.Localization.*

public class PSSLocalizationProvider extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    switch language {
      // case n"fr-fr": return new PSSLanguageFrench();
      default: return new PSSLanguageEnglish();
    }
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

public class PSSLanguageEnglish extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("ParkingSpotSpawner-NoVehicles", "You don't own any vehicles yet.");
    this.Text("ParkingSpotSpawner-NoSpot", "Look at the ground within 30 metres.");
    this.Text("ParkingSpotSpawner-PlacingMeter", "Aim at the ground where the PARKING marking goes, then press the key again.");
    this.Text("ParkingSpotSpawner-PlacingVehicle", "Marking set. Line up the vehicle, then press the key again to save the spot.");
    this.Text("ParkingSpotSpawner-PlacingStopped", "Stopped placing.");
    this.Text("ParkingSpotSpawner-SpotSaved", "Parking spot saved. Walk up to the PARKING marking to bring out a vehicle.");
    this.Text("ParkingSpotSpawner-SpotRemoved", "Removed the parking spot.");
    this.Text("ParkingSpotSpawner-NoSpotNearby", "There is no parking spot within five metres.");
    this.Text("ParkingSpotSpawner-SpotLocked", "Parking spot locked.");
    this.Text("ParkingSpotSpawner-SpotUnlocked", "Parking spot unlocked.");
    this.Text("ParkingSpotSpawner-SpotIsLocked", "That parking spot is locked. Unlock it to remove it.");

    // Removing all spots at once, from Mod Settings
    this.Text("ParkingSpotSpawner-NoSpots", "There are no parking spots to remove.");
    this.Text("ParkingSpotSpawner-AllLocked", "Every parking spot is locked, so none were removed.");
    this.Text("ParkingSpotSpawner-RemovedAll", "Parking spots removed: {COUNT}.");
    this.Text("ParkingSpotSpawner-RemovedAllKept", "Parking spots removed: {COUNT}. Locked ones kept: {KEPT}.");

    // The prompt on a spot's marking
    this.Text("ParkingSpotSpawner-MeterTitle", "Parking spot");
    this.Text("ParkingSpotSpawner-MeterTitleLocked", "Parking spot (locked)");
    this.Text("ParkingSpotSpawner-BringOut", "Bring out {NAME}");
    this.Text("ParkingSpotSpawner-PutAway", "Put away {NAME}");
    this.Text("ParkingSpotSpawner-ChooseVehicle", "Choose vehicle");
    this.Text("ParkingSpotSpawner-Blocked", "Another vehicle is on the spot");

    this.Text("ParkingSpotSpawner-CantBringOut", "That vehicle can't be brought out right now.");
    this.Text("ParkingSpotSpawner-Facing-TowardMeter", "Vehicles will face the marking.");
    this.Text("ParkingSpotSpawner-Facing-AwayFromMeter", "Vehicles will face away from the marking.");
    this.Text("ParkingSpotSpawner-Facing-SideLeft", "Vehicles will park side-on, nose to the left.");
    this.Text("ParkingSpotSpawner-Facing-SideRight", "Vehicles will park side-on, nose to the right.");
  }
}
