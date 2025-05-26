cask "kopiaui" do
  arch arm: "-arm64"

  version "0.20.1"
  sha256 arm:   "9c0c802bfc4fb68f1a4e0a57a611d761d467fc84627a416eacc8e083e9f8a71d",
         intel: "9f1e2818cfc2fe7281be91dd985aec5f66f4669888832f9bbae810453cd2f3fb"

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
  depends_on macos: ">= :big_sur"

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