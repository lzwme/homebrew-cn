cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.88"
  sha256 arm:   "73ee3ba04ddc8b68e6f95abf7d0ebf902ae64a1eb0e656380d760e4e7b72e53f",
         intel: "748528c1764a0d5f0d0487e918800000466658af019153181e3fa336c6ee7bb7"

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