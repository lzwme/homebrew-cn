cask "socialstream" do
  arch arm: "arm64", intel: "x64"

  version "0.3.95"
  sha256 arm:   "ef67a4209310be6ae70f1a6cf55a1862386c0ebef1e62554f36a6bb6de6501a9",
         intel: "05b3c31f7ce744c3dcd6d48012928cedab2c7c2137c7e09bf3817d7341febe42"

  url "https://ghfast.top/https://github.com/steveseguin/social_stream/releases/download/#{version}/socialstreamninja_mac_v#{version}_#{arch}.dmg",
      verified: "github.com/steveseguin/social_stream/"
  name "Social Stream"
  name "Social Stream Ninja"
  desc "Consolidate, control, and customise live social messaging streams"
  homepage "https://socialstream.ninja/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "socialstream.app"

  zap trash: [
    "~/Library/Application Support/socialstream",
    "~/Library/Preferences/socialstream.electron.plist",
    "~/Library/Saved Application State/socialstream.electron.savedState",
  ]
end