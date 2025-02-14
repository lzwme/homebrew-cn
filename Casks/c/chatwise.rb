cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.73"
  sha256 arm:   "21554dcb18449e9fe3d18d29e7a53e82f605661f5ae429c143f2cfa6c5f865ad",
         intel: "cc3413a9b2ff390ac59bc20664bf1724a7cd65741de7e4e5c4d7e00831d4e0a0"

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