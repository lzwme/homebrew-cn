cask "simplex" do
  arch arm: "aarch64", intel: "x86_64"

  version "6.2.4"
  sha256 arm:   "7c8318ad5cbb768b6e6f704ce3c202bfe1151a4a2a360d457ef4ea1a6c0cd6fc",
         intel: "5dcae2da15b3a11a17455e222ff77d2e2a3a0ae8d4207e97babb8793fd77f201"

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