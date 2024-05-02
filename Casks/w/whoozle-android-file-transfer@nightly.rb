cask "whoozle-android-file-transfer@nightly" do
  version :latest
  sha256 :no_check

  url "https:github.comwhoozleandroid-file-transfer-linuxreleasesdownloadcontinuousAndroidFileTransferForLinux.dmg",
      verified: "github.comwhoozleandroid-file-transfer-linux"
  name "Android File Transfer"
  desc "Android File Transfer for Linux"
  homepage "https:whoozle.github.ioandroid-file-transfer-linux"

  deprecate! date: "2025-05-01", because: :unsigned

  conflicts_with cask: "whoozle-android-file-transfer"
  depends_on macos: ">= :sierra"

  app "Android File Transfer for Linux.app"
  binary "#{appdir}Android File Transfer for Linux.appContentsSharedSupportbinaft-mtp-cli"
  binary "#{appdir}Android File Transfer for Linux.appContentsSharedSupportbinaft-mtp-mount"

  # No zap stanza required
end