cask "kopiaui" do
  arch arm: "-arm64"

  version "0.16.0"
  sha256 arm:   "3a638d034f063a6a162d1e217efdbbee4309b950c5d1de090ecef6be5a10f850",
         intel: "4bd3e663a7b9db0635770b8019718efee4d66ffdb334e756be6daff238cc84d5"

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