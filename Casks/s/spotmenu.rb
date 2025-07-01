cask "spotmenu" do
  version "2.0.5"
  sha256 "2aab71ab15f60079b31705b6a493c3062e8c754c3f6d756abc3720fcf4fade49"

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