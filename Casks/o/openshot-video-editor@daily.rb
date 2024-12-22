cask "openshot-video-editor@daily" do
  version "3.2.1,13156-1107e9ff-61690911"
  sha256 "09c3193c60b73b460c7e2c57753d97b58365246c5dd62971c5bce2e9955a9634"

  url "https:github.comOpenShotopenshot-qtreleasesdownloaddailyOpenShot-v#{version.csv.first}-dev-daily-#{version.csv.second}-x86_64.dmg",
      verified: "github.comOpenShotopenshot-qt"
  name "OpenShot Video Editor (Daily Build)"
  desc "Cross-platform video editor"
  homepage "https:openshot.org"

  livecheck do
    url "https:www.openshot.orgdownload"
    regex(OpenShot[._-]v?(\d+(?:\.\d+)+)[._-]dev[._-]daily[._-](.*)[._-]x86[._-]64\.dmg"i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  conflicts_with cask: "openshot-video-editor"
  depends_on macos: ">= :catalina"

  app "OpenShot Video Editor.app"

  zap trash: [
    "~.openshot_qt",
    "~LibraryApplication Supportopenshot",
    "~LibraryPreferencesopenshot-qt.plist",
  ]

  caveats do
    requires_rosetta
  end
end