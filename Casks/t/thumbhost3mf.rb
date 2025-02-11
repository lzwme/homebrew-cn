cask "thumbhost3mf" do
  version "1.7.1"
  sha256 "76c6ad0cb2cefb2ef88efd96949afe0b8f03573871d0192146a6083df5d6e19e"

  url "https:github.comDavidPhillipOsterThumbHost3mfreleasesdownload#{version}ThumbHost3mf#{version}.zip"
  name "ThumbHost3mf"
  desc "Finder thumbnail provider for some .gcode, .bgcode and .3mf files"
  homepage "https:github.comDavidPhillipOsterThumbHost3mf"

  depends_on macos: ">= :catalina"

  app "ThumbHost3mf.app"

  zap trash: "~LibraryContainerscom.turbozen.-mfQuickLookDataLibraryPreferencescom.turbozen.-mfQuickLook.plist"
end