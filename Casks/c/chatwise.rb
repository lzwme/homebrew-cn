cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.12"
  sha256 arm:   "05586f7df42fc9ffd650eb86a87254fbdc1e24e0d9259f2ad7c5ce4633ac9d87",
         intel: "b19280f26c20fa09b0bb2daaa25e8e126c02b103e0d4c8eafea7198e25cd5f02"

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