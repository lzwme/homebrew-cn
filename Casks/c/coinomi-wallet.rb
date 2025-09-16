cask "coinomi-wallet" do
  version "1.2.4"
  sha256 "da8de4e58b4de69454449e4aad2f69daab658c40c6669d8b2e2d434b26c5dcf4"

  url "https://storage.coinomi.com/binaries/desktop/coinomi-wallet-#{version}-macos.dmg",
      user_agent: :fake
  name "Coinomi Wallet"
  desc "Securely store, manage and exchange many blockchain assets"
  homepage "https://www.coinomi.com/en/"

  deprecate! date: "2025-05-25", because: :moved_to_mas

  app "Coinomi Wallet.app"

  uninstall quit: "com.coinomi.desktop"

  zap trash: [
    "~/Library/Application Support/Coinomi",
    "~/Library/Caches/Coinomi",
    "~/Library/Saved Application State/com.coinomi.desktop.savedState",
  ]

  caveats do
    requires_rosetta
  end
end