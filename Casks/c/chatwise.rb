cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.5"
  sha256 arm:   "e151ab610468dc03ba63b36d4dc4df806cdac4af0e91cba31a43d5e63ade4602",
         intel: "3b043ca4d7bc8fcafb53a9e98161fdd796eaae832c57c9e6a91457f297cab116"

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