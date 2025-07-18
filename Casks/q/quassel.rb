cask "quassel" do
  version "0.14.0"
  sha256 "cb8b195cd9961c8af26a9df7f5411aa1f23324d1ee717f7c4df8abc2b70021a2"

  url "https://ghfast.top/https://github.com/quassel/quassel/releases/download/#{version}/QuasselMono-MacOS-#{version}.dmg",
      verified: "github.com/quassel/quassel/"
  name "Quassel"
  desc "IRC client"
  homepage "https://quassel-irc.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Quassel.app"

  zap trash: [
    "~/Library/Application Support/Quassel",
    "~/Library/Preferences/org.quassel-irc.quasselclient.plist",
    "~/Library/Preferences/org.quassel-irc.quasselcore.plist",
    "~/Library/Saved Application State/org.quassel-irc.client.savedState",
  ]

  caveats do
    requires_rosetta
  end
end