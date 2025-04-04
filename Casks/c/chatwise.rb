cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.23"
  sha256 arm:   "97170ba62f68f2d58e527f0bb53737cfbe97af8b7c07eed3bcbd909680edefef",
         intel: "f2da9b89b07253a4c5fe484f10f8b5ba5bda89ce99d86aae2e6d39566c4e2cbe"

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