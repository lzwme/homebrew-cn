cask "openshot-video-editor-daily" do
  version "3.1.1,11721-d98b5f2f-8e9d7edc"
  sha256 "f92e9712cb38858e80207a68123f2bf8dbcf9acc69104d0b5c6dddecbd587040"

  url "https:github.comOpenShotopenshot-qtreleasesdownloaddailyOpenShot-v#{version.csv.first}-daily-#{version.csv.second}-x86_64.dmg",
      verified: "github.comOpenShotopenshot-qt"
  name "OpenShot Video Editor (Daily Build)"
  desc "Cross-platform video editor"
  homepage "https:openshot.org"

  livecheck do
    url "https:www.openshot.orgdownload"
    regex(OpenShot[._-]v?(\d+(?:\.\d+)+)[._-]daily[._-](.*)[._-]x86[._-]64\.dmg"i)
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
end