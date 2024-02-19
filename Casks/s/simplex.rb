cask "simplex" do
  arch arm: "aarch64", intel: "x86_64"

  version "5.5.4"
  sha256 arm:   "c187393eab71b872e814aeb9f8d896e09ab8daec63ef301f8e231aa9f069ff44",
         intel: "01d82774a8e9d87a497b4c659b464438b522675cb67abb0bf3e566a65562dd4e"

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