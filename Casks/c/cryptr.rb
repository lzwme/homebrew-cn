cask "cryptr" do
  version "0.6.0"
  sha256 "22f526a8f804c203148034eba3704f0478f58b1bf2ee3999e1a199b3b52eefd5"

  url "https://ghfast.top/https://github.com/adobe/cryptr/releases/download/v#{version}/Cryptr-#{version}.dmg"
  name "Cryptr"
  desc "GUI for Hashicorp's Vault"
  homepage "https://github.com/adobe/cryptr"

  deprecate! date: "2024-10-04", because: :unmaintained
  disable! date: "2025-10-04", because: :unmaintained

  app "Cryptr.app"

  zap trash: [
    "~/Library/Application Support/cryptr",
    "~/Library/Preferences/io.cryptr.plist",
    "~/Library/Saved Application State/io.cryptr.savedState",
  ]

  caveats do
    requires_rosetta
  end
end