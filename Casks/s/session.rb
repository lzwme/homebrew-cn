cask "session" do
  arch arm: "arm64", intel: "x64"

  version "1.17.11"
  sha256 arm:   "63918121b8b34ca9c71216fb9d5dc015ee70b26886942c70324573a162ab8f39",
         intel: "f8f436b0cb6ea9a2d0da97350ced20c4b15de1e223d97b33a7b7c77422514540"

  url "https://ghfast.top/https://github.com/session-foundation/session-desktop/releases/download/v#{version}/session-desktop-mac-#{arch}-#{version}.dmg",
      verified: "github.com/session-foundation/session-desktop/"
  name "Session"
  desc "Onion routing based messenger"
  homepage "https://getsession.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Session.app"

  zap trash: [
    "~/Library/Application Support/Session",
    "~/Library/Caches/Session",
    "~/Library/Preferences/com.loki-project.messenger-desktop.plist",
    "~/Library/Saved Application State/com.loki-project.messenger-desktop.savedState",
  ]
end