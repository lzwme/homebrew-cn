cask "simplex" do
  arch arm: "aarch64", intel: "x86_64"

  version "5.7.3"
  sha256 arm:   "94cdc132d6158eddded25c2e2d2ce7e02b276c8f8c889d3122fc919e22568c72",
         intel: "9c6393aa70858b2d1c371e2b22a75c2aa1a7fd31ad7dafe5f76cb9004874ecb9"

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