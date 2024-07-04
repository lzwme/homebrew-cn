cask "simplex" do
  arch arm: "aarch64", intel: "x86_64"

  version "5.8.2"
  sha256 arm:   "870f97f3b11c319df44439332e5b6392dd846f70ee74e72adaa67c4bb5bcda30",
         intel: "b857d948445159c333a82628bb65f547fdb49a273454aeb2759bf64e59b4870e"

  url "https:github.comsimplex-chatsimplex-chatreleasesdownloadv#{version}simplex-desktop-macos-#{arch}.dmg",
      verified: "github.comsimplex-chatsimplex-chat"
  name "SimpleX Chat"
  desc "Messenger for SimpleX protocol"
  homepage "https:simplex.chat"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "SimpleX.app"

  zap trash: "~LibrarySaved Application Statechat.simplex.app.savedState"
end