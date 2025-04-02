cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.20"
  sha256 arm:   "977308b90128d972cae24a68af558e59f824e6fb27dad6e112be587976e0521c",
         intel: "67f3d593bb8b9bc6c1865d629dfe03bdbbec39701f2195d1e8c3662c56f50e57"

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