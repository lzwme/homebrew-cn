cask "kopiaui" do
  arch arm: "-arm64"

  version "0.16.1"
  sha256 arm:   "109c3a2e1bebdc43e2425a742f3bd795f4a64b7adce3a2ff60a5354e1dc4e69a",
         intel: "479416fe5b720cf05b919959b5032bfdb2df86cfcbd3c6a9c38e664dedc19699"

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