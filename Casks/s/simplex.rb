cask "simplex" do
  arch arm: "aarch64", intel: "x86_64"

  version "6.3.0"
  sha256 arm:   "666065b2783fb653a0953ce119c90ec7caab8b5f3785329e0887434c5b58a571",
         intel: "e76abd3c5fb65ad6fb200125a04193ca0e0c2063c53c593469d9153f613a00bb"

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