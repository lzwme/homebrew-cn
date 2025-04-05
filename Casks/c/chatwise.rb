cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.25"
  sha256 arm:   "ec66155672031146e54129c9ea2f58468680d9304f32931899b8b459cf09fd70",
         intel: "016a49be1ab852171026e0baad62ea8d8469f357cee63e7e9fc4216d4a280f94"

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