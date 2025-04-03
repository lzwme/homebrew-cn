cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.22"
  sha256 arm:   "8f675367f48799e99a72dcb48fee4a8ad0b87bb8de5034ee2b3c8956be45b14b",
         intel: "1d38c42f48ec48488ad3061af530585fe91817b8d33fa28c8440907f358f2c16"

  url "https:github.comegoistchatwise-releasesreleasesdownloadv#{version}ChatWise_#{version}_#{arch}.dmg",
      verified: "github.comegoistchatwise-releases"
  name "ChatWise"
  desc "AI chatbot for many LLMs"
  homepage "https:chatwise.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "ChatWise.app"

  uninstall quit: "app.chatwise"

  zap trash: [
    "~LibraryApplication Supportapp.chatwise",
    "~LibraryCachesapp.chatwise",
    "~LibrarySaved Application Stateapp.chatwise.savedState",
    "~LibraryWebKitapp.chatwise",
  ]
end