cask "vivaldi@snapshot" do
  version "6.8.3356.3"
  sha256 "186774633355ace23861b370b25e121dd7647161f41715c207fc761daaa6d913"

  url "https://downloads.vivaldi.com/snapshot-auto/Vivaldi.#{version}.universal.tar.xz"
  name "Vivaldi Snapshot"
  desc "Web browser with built-in email client focusing on customization and control"
  homepage "https://vivaldi.com/"

  livecheck do
    url "https://update.vivaldi.com/update/1.0/snapshot/mac/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Vivaldi Snapshot.app"

  uninstall quit: "com.vivaldi.Vivaldi.snapshot"

  zap trash: [
    "~/Library/Application Support/Vivaldi Snapshot",
    "~/Library/Caches/com.vivaldi.Vivaldi.snapshot",
    "~/Library/Caches/Vivaldi Snapshot",
    "~/Library/HTTPStorages/com.vivaldi.Vivaldi.snapshot",
    "~/Library/Preferences/com.vivaldi.Vivaldi.snapshot.plist",
    "~/Library/Saved Application State/com.vivaldi.Vivaldi.snapshot.savedState",
    "~/Library/WebKit/com.vivaldi.Vivaldi.snapshot",
  ]
end