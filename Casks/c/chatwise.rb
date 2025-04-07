cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.28"
  sha256 arm:   "2cef737ad89d829ddf31db0a0e187f2bf2f938a1772d5e40553ec888cbd5aa5b",
         intel: "4164faa4a344cd5fcc33298d5c9551af56b3be9c66290094c7f2c29e43ce65e4"

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