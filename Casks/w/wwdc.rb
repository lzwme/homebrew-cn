cask "wwdc" do
  version "7.5,1044"
  sha256 "539aead52153a6decde115ba75f5a60848cbbdbd7bca3472347e5fc9d449d20c"

  url "https:github.cominsideguiWWDCreleasesdownload#{version.csv.first}WWDC_v#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.cominsideguiWWDC"
  name "WWDC"
  desc "Allows access to WWDC livestreams, videos and sessions"
  homepage "https:wwdc.io"

  livecheck do
    url :url
    regex(^WWDC[._-]v?(\d+(?:[.-]\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1].tr("-", ",")
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "WWDC.app"

  zap trash: [
    "~LibraryApplication Supportio.wwdc.app",
    "~LibraryApplication Supportio.wwdc.app.TranscriptIndexingService",
    "~LibraryApplication SupportWWDC",
    "~LibraryPreferencesio.wwdc.app.plist",
  ]
end