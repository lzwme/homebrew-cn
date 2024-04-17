cask "kopiaui" do
  arch arm: "-arm64"

  version "0.17.0"
  sha256 arm:   "9eb1d11c749aab2ce05db801bc7090b140337b0c6eff6d7242f74f2a08bb4b5a",
         intel: "358b7ee3a3be8f23682ad55e6c505b67841fdf6495da4f8ed7af407ad14cc27e"

  url "https:github.comkopiakopiareleasesdownloadv#{version}KopiaUI-#{version}#{arch}.dmg",
      verified: "github.comkopiakopia"
  name "KopiaUI"
  desc "Backuprestore tool"
  homepage "https:kopia.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "KopiaUI.app"

  zap trash: [
    "~LibraryApplication Supportkopia",
    "~LibraryCacheskopia",
    "~LibraryLogskopia",
    "~LibraryLogskopia-ui",
    "~LibraryPreferencesio.kopia.ui.plist",
    "~LibrarySaved Application Stateio.kopia.ui.savedState",
  ]
end