cask "spotmenu" do
  version "1.9"
  sha256 "306fc07e2fa2987bd46eae15012808ab2341e47bc56c7b0ebef151752155fd6f"

  url "https:github.comkmikiySpotMenureleasesdownloadv#{version}SpotMenu.zip"
  name "SpotMenu"
  desc "Spotify and iTunes in the menu bar"
  homepage "https:github.comkmikiySpotMenu"

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "SpotMenu.app"

  uninstall quit:       "com.KMikiy.SpotMenu",
            login_item: "SpotMenu"

  zap trash: [
    "~LibraryApplication Scriptscom.KMikiy.SpotMenu.SpotMenuToday",
    "~LibraryApplication Supportcom.KMikiy.SpotMenu",
    "~LibraryContainerscom.KMikiy.SpotMenu.SpotMenuToday",
    "~LibraryGroup Containersgroup.KMikiy.SpotMenu",
    "~LibraryPreferencescom.KMikiy.SpotMenu.plist",
  ]

  caveats do
    requires_rosetta
  end
end