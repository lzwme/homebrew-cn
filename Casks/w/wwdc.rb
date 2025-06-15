cask "wwdc" do
  version "7.5,1044"
  sha256 "539aead52153a6decde115ba75f5a60848cbbdbd7bca3472347e5fc9d449d20c"

  url "https:github.cominsideguiWWDCreleasesdownload#{version.csv.first}WWDC_v#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.cominsideguiWWDC"
  name "WWDC"
  desc "Allows access to WWDC livestreams, videos and sessions"
  homepage "https:wwdc.io"

  livecheck do
    url "https:github.cominsideguiWWDCrawmasterReleasesappcast_v5.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :monterey"

  app "WWDC.app"

  zap trash: [
    "~LibraryApplication Supportio.wwdc.app",
    "~LibraryApplication Supportio.wwdc.app.TranscriptIndexingService",
    "~LibraryApplication SupportWWDC",
    "~LibraryPreferencesio.wwdc.app.plist",
  ]
end