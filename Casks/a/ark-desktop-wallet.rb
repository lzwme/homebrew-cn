cask "ark-desktop-wallet" do
  version "2.9.5"
  sha256 "2ac74aa43c474fe51db57bbcb52cad13d0d51ef276f0088c7cfe36261790c272"

  url "https:github.comArkEcosystemdesktop-walletreleasesdownload#{version}ark-desktop-wallet-mac-#{version}.dmg",
      verified: "github.comArkEcosystemdesktop-wallet"
  name "Ark Desktop Wallet"
  desc "Multi Platform ARK Desktop Wallet"
  homepage "https:ark.io"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Ark Desktop Wallet.app"

  caveats do
    requires_rosetta
  end
end