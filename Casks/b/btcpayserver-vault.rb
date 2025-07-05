cask "btcpayserver-vault" do
  version "2.0.10"
  sha256 "fff1f489b170a2481cce696c7822ad42f531856ae7d9afc74efa51a2745a9e3d"

  url "https://ghfast.top/https://github.com/btcpayserver/BTCPayServer.Vault/releases/download/Vault%2Fv#{version}/BTCPayServerVault-osx-x64-#{version}.dmg"
  name "BTCPayServer Vault"
  desc "App that allows web applications to access a hardware wallet"
  homepage "https://github.com/btcpayserver/BTCPayServer.Vault"

  livecheck do
    url :url
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "BTCPayServer Vault.app"

  zap trash: "~/Library/Saved Application State/com.btcpayserver.vault.savedState"

  caveats do
    requires_rosetta
  end
end