cask "brewtarget" do
  version "3.0.11"
  sha256 "d8d7ae1583810bc05b8f9cb43c0d6c73e366a1467f9c6a1e9b206c864b12d36a"

  url "https:github.comBrewtargetbrewtargetreleasesdownloadv#{version}brewtarget_#{version}.dmg"
  name "brewtarget"
  desc "Beer recipe creation tool"
  homepage "https:github.comBrewtargetbrewtarget"

  app "brewtarget_#{version}.app"

  zap trash: [
    "~LibraryPreferencesbrewtarget",
    "~LibraryPreferencescom.brewtarget.Brewtarget.plist",
    "~LibrarySaved Application Statecom.brewtarget.Brewtarget.savedState",
  ]

  caveats do
    requires_rosetta
  end
end