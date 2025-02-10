cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.59"
  sha256 arm:   "070315655072f0f9f8fe27bd4876e0fda4826cd0a3b430d518f9ebe2926bce5d",
         intel: "8ceb244f38eb8a5023e14d057ac559dfd6b0f213880f8311811d980885c741c1"

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