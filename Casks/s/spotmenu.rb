cask "spotmenu" do
  version "2.0.3"
  sha256 "815ca65ee7ae8a7f783fa25ec290557af1a0a6e6f76e77c7e7e44a6d608c7d6e"

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