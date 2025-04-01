cask "whoozle-android-file-transfer" do
  version "4.4"
  sha256 "d99af1a1d2da16219e829caa553a68d506662e5171e78ce2a81c390dfd01a12a"

  url "https:github.comwhoozleandroid-file-transfer-linuxreleasesdownloadv#{version}AndroidFileTransferForLinux.dmg",
      verified: "github.comwhoozleandroid-file-transfer-linux"
  name "Android File Transfer"
  desc "Android File Transfer for Linux"
  homepage "https:whoozle.github.ioandroid-file-transfer-linux"

  conflicts_with cask: "whoozle-android-file-transfer@nightly"
  depends_on macos: ">= :sierra"

  app "Android File Transfer for Linux.app"
  binary "#{appdir}Android File Transfer for Linux.appContentsSharedSupportbinaft-mtp-cli"
  binary "#{appdir}Android File Transfer for Linux.appContentsSharedSupportbinaft-mtp-mount"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end