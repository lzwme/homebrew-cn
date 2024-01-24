cask "windterm" do
  version "2.6.0"
  sha256 "f9343ba28070d5039a89600133e06e0e3e023d67cd9540aae437f055417ce019"

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