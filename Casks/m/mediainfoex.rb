cask "mediainfoex" do
  version "1.7.2"
  sha256 "50d15c662c9c2ab630bde927d956b026182a42b0ca51a080d3eca10006705f86"

  url "https:github.comsbarexMediaInforeleasesdownload#{version}MediaInfo.zip"
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