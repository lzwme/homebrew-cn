cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.13"
  sha256 arm:   "b998cbe0ea1299b5ecd3ef595d8199ec565b03674bda66816a344a336ee9aafc",
         intel: "5b79bc4bb7859f24df34ac9dd5fc32116ef7e4a586b971eaf311799db25fe202"

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