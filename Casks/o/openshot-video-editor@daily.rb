cask "openshot-video-editor@daily" do
  version "3.3.0,13873-cdaccf2e-5bd5f2da"
  sha256 "b9e1645382d8d18efa76d7f1e7da5d179052301d3b95153a1593ae7ed887e8db"

  url "https:github.comOpenShotopenshot-qtreleasesdownloaddailyOpenShot-v#{version.csv.first}-daily-#{version.csv.second}-x86_64.dmg",
      verified: "github.comOpenShotopenshot-qt"
  name "OpenShot Video Editor (Daily Build)"
  desc "Cross-platform video editor"
  homepage "https:openshot.org"

  livecheck do
    url "https:www.openshot.orgdownload"
    regex(OpenShot[._-]v?(\d+(?:\.\d+)+)(?:[._-]dev)?[._-]daily[._-](.*)[._-]x86[._-]64\.dmg"i)
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