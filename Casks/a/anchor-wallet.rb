cask "anchor-wallet" do
  version "1.3.12"
  sha256 "043f92369bf5dbc41d48ce6439eb2138017bc7f21694c60e2eab9d321a819508"

  url "https:github.comgreymassanchorreleasesdownloadv#{version}mac-anchor-wallet-#{version}-x64.dmg",
      verified: "github.comgreymassanchor"
  name "Anchor Wallet"
  desc "EOSIO Desktop Wallet and Authenticator"
  homepage "https:www.greymass.comanchor"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :el_capitan"

  app "Anchor Wallet.app"

  zap trash: [
    "~LibraryApplication SupportAnchor Wallet",
    "~LibraryCachescom.greymass.anchordesktop.release",
    "~LibraryCachescom.greymass.anchordesktop.release.ShipIt",
    "~LibraryLogsAnchor Wallet",
    "~LibraryPreferencesByHostcom.greymass.anchordesktop.release.ShipIt.*.plist",
    "~LibraryPreferencescom.greymass.anchordesktop.release.plist",
    "~LibrarySaved Application Statecom.greymass.anchordesktop.release.savedState",
  ]

  caveats do
    requires_rosetta
  end
end