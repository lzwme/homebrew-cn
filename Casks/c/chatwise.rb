cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.32"
  sha256 arm:   "0509ebac0fd5663d0533e187caca2cc0ae3c191bec8fda8d465ebf967d864b6e",
         intel: "da2447223b316248436ac49107a1c1d9c6aa4b7380b52ee1cc4b886efd62b133"

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