cask "kopiaui" do
  arch arm: "-arm64"

  version "0.18.0"
  sha256 arm:   "3435c4083411fde83dde2ccab847783f6667108fe0acbb0d66eaceb810831be6",
         intel: "0789b8495ec0e14f61746ea64cb7564dfe7a8647f8dc544ed80a2478ecfd0136"

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