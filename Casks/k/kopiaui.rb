cask "kopiaui" do
  arch arm: "-arm64"

  version "0.18.1"
  sha256 arm:   "6022e2692cf6f3a6ddbdefc679f430144b522c498d6f3f26c3bd2f356a56a0f6",
         intel: "a0af31ae6600a3d8b78bd532a966b2cec35720f8bfe5957a59683c7b33208ed2"

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