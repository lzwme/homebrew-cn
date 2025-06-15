cask "mediainfoex" do
  version "1.7.4"
  sha256 "7f2cbb113f6bfff49541487d73ce8b6dc3e4b28a7d2832afbcd45dca6b891481"

  url "https:github.comsbarexMediaInforeleasesdownload#{version}MediaInfoEx.zip"
  name "MediaInfo"
  desc "Display file information in Finder contextual menu"
  homepage "https:github.comsbarexMediaInfo"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "MediaInfoEx.app"

  zap trash: [
    "~LibraryApplication Scriptsorg.sbarex.MediaInfo",
    "~LibraryApplication Scriptsorg.sbarex.MediaInfo.Finder-Extension",
    "~LibraryContainersMediaInfo Finder Extension",
    "~LibraryContainersorg.sbarex.MediaInfo",
    "~LibraryPreferencesorg.sbarex.MediaInfo.plist",
  ]
end