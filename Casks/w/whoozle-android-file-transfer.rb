cask "whoozle-android-file-transfer" do
  version "4.3"
  sha256 "161996a15752183c5aa66682b37030f689b514b6183a5ee464de63b1980c8424"

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