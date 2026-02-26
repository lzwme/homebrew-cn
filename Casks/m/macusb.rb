cask "macusb" do
  version "2.0"
  sha256 "9b3051c2748a7929c141a65c793acfad8dbc4b22e69e8afbdf5e69f0a016005b"

  url "https://ghfast.top/https://github.com/Kruszoneq/macUSB/releases/download/v#{version}/macUSB.#{version}.dmg",
      verified: "github.com/Kruszoneq/macUSB/"
  name "macUSB"
  desc "Tool to create bootable USB installers"
  homepage "https://kruszoneq.github.io/macUSB/"

  depends_on macos: ">= :sonoma"

  app "macUSB.app"

  zap trash: [
    "~/Library/Application Support/macUSB",
    "~/Library/Caches/com.kruszoneq.macusb",
    "~/Library/Preferences/com.kruszoneq.macusb.plist",
    "~/Library/Saved Application State/com.kruszoneq.macusb.savedState",
  ]
end