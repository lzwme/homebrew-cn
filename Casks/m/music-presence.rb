cask "music-presence" do
  arch arm: "arm64", intel: "x86_64"

  version "2.3.1"
  sha256 arm:   "8d4ee30b1b32f48a2642b6dad9e68e249e8e6ea80509d772f851cb013bfa26d5",
         intel: "0514627a3fa76f4467f809a9c89fd31c6125bf14380011e2380a1363c59c13d3"

  url "https://ghfast.top/https://github.com/ungive/discord-music-presence/releases/download/v#{version}/musicpresence-#{version}-mac-#{arch}.dmg",
      verified: "github.com/ungive/discord-music-presence/"
  name "Music Presence"
  desc "Discord music status that works with any media player"
  homepage "https://musicpresence.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Music Presence.app"

  zap trash: [
    "~/Library/Application Support/Music Presence",
    "~/Library/Preferences/app.musicpresence.desktop.plist",
  ]

  caveats do
    license "https://github.com/ungive/discord-music-presence/blob/v#{version}/LICENSE.md"
  end
end