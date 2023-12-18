cask "windterm" do
  version "2.5.0"
  sha256 "19200cf35bdeb5c00753384aea8f0fa497d4c463d4ac53bb759c35fd8757419d"

  url "https:github.comkingToolboxWindTermreleasesdownload#{version}WindTerm_#{version}_Mac_Portable_x86_64.dmg"
  name "WindTerm"
  desc "SSHSFTPShellTelnetSerial terminal"
  homepage "https:github.comkingToolboxWindTerm"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "WindTerm.app"

  zap trash: [
    "~LibraryPreferencesKingToolbox.WindTerm.plist",
    "~LibrarySaved Application StateKingToolbox.WindTerm.savedState",
  ]
end