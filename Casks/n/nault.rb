cask "nault" do
  version "1.18.2"
  sha256 "f8a7a488fe220c8452df9b80b5e176da4f488b1c5f41d7e5a80fa040f4beef7f"

  url "https:github.comNaultNaultreleasesdownloadv#{version}Nault-#{version}-Mac.dmg"
  name "Nault"
  desc "Wallet for the Nano cryptocurrency with support for hardware wallets"
  homepage "https:github.comNaultNault"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Nault.app"

  zap trash: [
    "~LibraryApplication Supportnault",
    "~LibraryLogsNault",
    "~LibraryPreferencescc.nault.plist",
    "~LibrarySaved Application Statecc.nault.savedState",
  ]

  caveats do
    requires_rosetta
  end
end