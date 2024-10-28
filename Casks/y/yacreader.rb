cask "yacreader" do
  version "9.14.2.2402143"
  sha256 "ee59a7f6b13216ff01dc00aa50c19c35121c074260d5be9a38bac67854a52054"

  url "https:github.comYACReaderyacreaderreleasesdownload#{version.major_minor_patch}YACReader-#{version}.MacOSX-U.Qt6.dmg",
      verified: "github.comYACReaderyacreader"
  name "YACReader"
  desc "Comic reader"
  homepage "https:www.yacreader.com"

  livecheck do
    url :url
    regex(^YACReader[._-]v?(\d+(?:\.\d+)+)[._-]MacOSX[._-]U[._-]Qt6\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
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