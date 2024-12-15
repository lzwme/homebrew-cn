cask "simplex" do
  arch arm: "aarch64", intel: "x86_64"

  version "6.2.1"
  sha256 arm:   "842c2f56b40448eed5bc618a47a604b7792f9bbc51726155d53e9820e7c34cd9",
         intel: "73e27e42564e36195cb9a8e904304e781f9f46336758ba8e23061d74cb0e2b26"

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