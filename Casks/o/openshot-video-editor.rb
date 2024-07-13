cask "openshot-video-editor" do
  version "3.2.1"
  sha256 "f5e63b893cb875e538618724e22d86749ce50aac584d547510374f6714ebcea6"

  url "https:github.comOpenShotopenshot-qtreleasesdownloadv#{version}OpenShot-v#{version}-x86_64.dmg",
      verified: "github.comOpenShotopenshot-qt"
  name "OpenShot Video Editor"
  desc "Cross-platform video editor"
  homepage "https:openshot.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: "openshot-video-editor@daily"
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