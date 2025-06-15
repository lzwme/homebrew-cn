cask "trinity" do
  version "1.6.2"
  sha256 "c37926a9612e8a8360490b6b924b1a2922a4374377e428f24b985f45de66ad68"

  url "https:github.comiotaledgertrinity-walletreleasesdownloaddesktop-#{version}trinity-desktop-#{version}.dmg",
      verified: "github.comiotaledgertrinity-wallet"
  name "IOTA Trinity Wallet"
  desc "Cryptocurrency wallet"
  homepage "https:trinity.iota.org"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Trinity.app"

  uninstall quit: "org.iota.trinity"

  zap trash: [
    "~LibraryApplication SupportTrinity",
    "~LibraryLogsTrinity",
    "~LibraryPreferencesorg.iota.trinity.helper.plist",
    "~LibraryPreferencesorg.iota.trinity.plist",
    "~LibrarySaved Application Stateorg.iota.trinity.savedState",
  ]
end