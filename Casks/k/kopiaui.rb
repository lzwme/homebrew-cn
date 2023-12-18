cask "kopiaui" do
  arch arm: "-arm64"

  version "0.15.0"
  sha256 arm:   "0d63198e1632d54d9eda0dee8d805707491f77856d802bb434be4da156027d7e",
         intel: "58e4dbac8a4f1ee57067877a137d0da234baab783daf10d68397dd63fca92bce"

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