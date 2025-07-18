cask "trinity" do
  version "1.6.2"
  sha256 "c37926a9612e8a8360490b6b924b1a2922a4374377e428f24b985f45de66ad68"

  url "https://ghfast.top/https://github.com/iotaledger/trinity-wallet/releases/download/desktop-#{version}/trinity-desktop-#{version}.dmg",
      verified: "github.com/iotaledger/trinity-wallet/"
  name "IOTA Trinity Wallet"
  desc "Cryptocurrency wallet"
  homepage "https://trinity.iota.org/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Trinity.app"

  uninstall quit: "org.iota.trinity"

  zap trash: [
    "~/Library/Application Support/Trinity",
    "~/Library/Logs/Trinity",
    "~/Library/Preferences/org.iota.trinity.helper.plist",
    "~/Library/Preferences/org.iota.trinity.plist",
    "~/Library/Saved Application State/org.iota.trinity.savedState",
  ]
end