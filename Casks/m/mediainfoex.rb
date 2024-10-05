cask "mediainfoex" do
  version "1.7.3"
  sha256 "a0e37188be0246673d7a24b2dcc79a9eb3872f29f89ec6c0dc704e042b435375"

  url "https:github.comsbarexMediaInforeleasesdownload#{version}MediaInfoEx.zip"
  name "MediaInfo"
  desc "Display file information in Finder contextual menu"
  homepage "https:github.comsbarexMediaInfo"

  depends_on macos: ">= :catalina"

  app "MediaInfoEx.app"

  zap trash: [
    "~LibraryApplication Scriptsorg.sbarex.MediaInfo",
    "~LibraryApplication Scriptsorg.sbarex.MediaInfo.Finder-Extension",
    "~LibraryContainersMediaInfo Finder Extension",
    "~LibraryContainersorg.sbarex.MediaInfo",
    "~LibraryPreferencesorg.sbarex.MediaInfo.plist",
  ]
end