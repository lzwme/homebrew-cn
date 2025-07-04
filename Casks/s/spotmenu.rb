cask "spotmenu" do
  version "2.1.0"
  sha256 "0b7b5727fa7ff9cceb6363f145cf16f3d09b38d2a1482c8745724c4b52e0ac99"

  url "https:github.comkmikiySpotMenureleasesdownloadv#{version}SpotMenu.app.zip"
  name "SpotMenu"
  desc "Spotify and iTunes in the menu bar"
  homepage "https:github.comkmikiySpotMenu"

  livecheck do
    url :url
    strategy :github_latest
  end

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