cask "kopiaui" do
  arch arm: "-arm64"

  version "0.18.2"
  sha256 arm:   "d85eb516873a7a74acf8cbff0e462c344555f7c98ee4614e48c736e1f6964ae1",
         intel: "45882a076621ac8969c66781397e55e251fa7b34b4ca2d320eec5b6b4d5ff40c"

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