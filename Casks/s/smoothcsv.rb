cask "smoothcsv" do
  version "3.0.0"
  sha256 "8c9470cd4adf50d66b14ba037304ff17cd10a3a2bb13b6e11a396e4efc246fbb"

  url "https:github.comkohiismoothcsv3releasesdownloadv#{version}SmoothCSV_#{version}_universal.dmg",
      verified: "github.comkohiismoothcsv3"
  name "SmoothCSV"
  desc "CSV editor"
  homepage "https:smoothcsv.com"

  depends_on macos: ">= :high_sierra"

  app "SmoothCSV.app"

  uninstall quit: "com.smoothcsv.desktop"

  zap trash: [
    "~LibraryApplication Supportcom.smoothcsv.desktop",
    "~LibraryCachescom.smoothcsv.desktop",
    "~LibraryLogscom.smoothcsv.desktop",
    "~LibraryWebKitcom.smoothcsv.desktop",
  ]
end