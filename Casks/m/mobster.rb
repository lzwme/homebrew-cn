cask "mobster" do
  version "0.0.48"
  sha256 "47ab506e59d9a3491f06943baecd1b225277e472ce71bc5052efc9d152712233"

  url "https:github.comdillonkearnsmobsterreleasesdownloadv#{version}Mobster-#{version}.dmg"
  name "Mobster"
  desc "Pair and mob programming timer"
  homepage "https:github.comdillonkearnsmobster"

  deprecate! date: "2024-07-27", because: :unmaintained

  app "Mobster.app"

  zap trash: [
    "~LibraryApplication SupportMobster",
    "~LibraryPreferencescom.dillonkearns.mobster.helper.plist",
    "~LibraryPreferencescom.dillonkearns.mobster.plist",
    "~LibrarySaved Application Statecom.dillonkearns.mobster.savedState",
  ]

  caveats do
    requires_rosetta
  end
end