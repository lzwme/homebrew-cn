cask "kopiaui" do
  arch arm: "-arm64"

  version "0.19.0"
  sha256 arm:   "f3dc21dd5042f051a605ec40e1ea050e52ad678e0a57573fce5b964dd4fc88e3",
         intel: "a1fa0d4efc947a04828d8a680a95be1537aeda336dbf417356d0bb1b8ba967ad"

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