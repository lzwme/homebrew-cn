cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.2"
  sha256 arm:   "4f3429cbcf5ecc923ed6b18b177f407f5c10de88e8690cc0dd53e3119a43b158",
         intel: "8061fc4cfdf78a6e35200e10289e79364cb9e6872adb576abc7e066a287d00e3"

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