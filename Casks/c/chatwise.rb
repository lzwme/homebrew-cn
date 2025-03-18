cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.3"
  sha256 arm:   "57f3a4aec26ffbb07cddc981746ee6d1b26e5b125ded0f682c2ac769c32d5b72",
         intel: "3834435e8b90bfc48e2d10d2d8b24d3e1c5d2b7c753af799f39e9391d7289db0"

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