cask "cryptr" do
  version "0.6.0"
  sha256 "22f526a8f804c203148034eba3704f0478f58b1bf2ee3999e1a199b3b52eefd5"

  url "https:github.comadobecryptrreleasesdownloadv#{version}Cryptr-#{version}.dmg"
  name "Cryptr"
  desc "GUI for Hashicorp's Vault"
  homepage "https:github.comadobecryptr"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Cryptr.app"

  zap trash: [
    "~LibraryApplication Supportcryptr",
    "~LibraryPreferencesio.cryptr.plist",
    "~LibrarySaved Application Stateio.cryptr.savedState",
  ]
end