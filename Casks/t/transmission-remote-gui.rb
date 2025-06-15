cask "transmission-remote-gui" do
  version "5.18.0"
  sha256 "fe32f0cdd5c8f9777bace0eceb92d6b269a2b20210f4cc0552112861ddead759"

  url "https:github.comtransmission-remote-guitransguireleasesdownloadv#{version}transgui-#{version}.dmg"
  name "Transmission Remote GUI"
  homepage "https:github.comtransmission-remote-guitransgui"

  no_autobump! because: :requires_manual_review

  app "Transmission Remote GUI.app"

  uninstall quit: "com.transgui"

  zap trash: [
    "~.configTransmission Remote GUI",
    "~LibraryPreferencescom.transgui.plist",
    "~LibrarySaved Application Statecom.transgui.savedState",
  ]

  caveats do
    requires_rosetta
  end
end