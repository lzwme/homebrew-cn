cask "yacreader" do
  version "9.13.1.2307166"
  sha256 "51f4b0f564aa4796e78e80efc0e1cff155d0fb89cc75579ee54d128d66d6998e"

  url "https:github.comYACReaderyacreaderreleasesdownload#{version.major_minor_patch}YACReader-#{version}.MacOSX-Intel.Qt6.dmg",
      verified: "github.comYACReaderyacreader"
  name "YACReader"
  desc "Comic reader"
  homepage "https:www.yacreader.com"

  livecheck do
    url "https:www.yacreader.comdownloads"
    regex(%r{href=.*?YACReader[._-]v?(\d+(?:\.\d+)+)[._-]MacOSX[._-]Intel[._-]Qt6\.dmg}i)
  end

  app "YACReader.app"
  app "YACReaderLibrary.app"

  zap trash: [
    "~LibraryApplication SupportYACReader",
    "~LibraryPreferencescom.yacreader.YACReader.plist",
    "~LibraryPreferencescom.yacreader.YACReaderLibrary.plist",
    "~LibrarySaved Application Statecom.yacreader.YACReader.savedState",
    "~LibrarySaved Application Statecom.yacreader.YACReaderLibrary.savedState",
  ]
end