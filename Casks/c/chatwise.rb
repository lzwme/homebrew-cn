cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.64"
  sha256 arm:   "ed4b72309f67068c0cac00368f6abe9a7d25a1882581f0d81f50490d50c5b655",
         intel: "92412910c227080d485e0ae1bf7aae25476351b3042e811864e42179c29a2262"

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