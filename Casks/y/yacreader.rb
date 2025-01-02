cask "yacreader" do
  version "9.15.0.2501014"
  sha256 "3fee3a0486738cb388dbbe7b11d78bbae2a32710f03dd6c5437bcf82ccac7d79"

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