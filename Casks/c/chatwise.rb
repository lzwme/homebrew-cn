cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.26"
  sha256 arm:   "a7955ede6f9c95d9180c6da45eac9846aadb9a6585a9966eb6c0d3d81b8b0314",
         intel: "eb882c51a1d823066b04941d2d81765b0ad32f9fce8cfeaa91c97d6212947829"

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