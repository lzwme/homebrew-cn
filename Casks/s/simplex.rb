cask "simplex" do
  arch arm: "aarch64", intel: "x86_64"

  version "6.1.0"
  sha256 arm:   "5d8262017ce0963f2dbe4cb366295b9be9a3c8a3e2819dd0f76dd681a2acb4d9",
         intel: "0653599cbfa4c037ed8053d4ecf884e263fc50c969916cb6b1478f45d306775f"

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