cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.11"
  sha256 arm:   "8d9664936c41539b68db915be9a7bc8ca36b78b282a3235b312125263123b0fc",
         intel: "5e452940cd23e959c3b5a97bab8851a3136a87bf3b0ffc0db2167f17754931f8"

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