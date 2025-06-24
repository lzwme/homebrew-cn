cask "spotmenu" do
  version "2.0.2"
  sha256 "499855efbc834ab99fc429a8355c4bc5da301c7a9116470bf39fa7e81d33ac95"

  url "https:github.comkmikiySpotMenureleasesdownloadv#{version}SpotMenu.app.zip"
  name "SpotMenu"
  desc "Spotify and iTunes in the menu bar"
  homepage "https:github.comkmikiySpotMenu"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "SpotMenu.app"

  uninstall quit:       "com.github.kmikiy.SpotMenu",
            login_item: "SpotMenu"

  zap trash: [
    "~LibraryApplication Scriptscom.github.kmikiy.SpotMenu",
    "~LibraryApplication Supportcom.github.kmikiy.SpotMenu",
    "~LibraryGroup Containerscom.github.kmikiy.SpotMenu",
    "~LibraryPreferencescom.github.kmikiy.SpotMenu.plist",
  ]
end