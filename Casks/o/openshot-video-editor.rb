cask "openshot-video-editor" do
  version "3.3.0"
  sha256 "bfa2dfbf5e3208ceebaf268e3bb8896e6dcbeb7af6d2c56d7f48c2fd849a3d1e"

  url "https:github.comOpenShotopenshot-qtreleasesdownloadv#{version}OpenShot-v#{version}-x86_64.dmg",
      verified: "github.comOpenShotopenshot-qt"
  name "OpenShot Video Editor"
  desc "Cross-platform video editor"
  homepage "https:openshot.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

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