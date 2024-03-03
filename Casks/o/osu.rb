cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.302.1"
  sha256 arm:   "d29768d4f2e3b31f080fa7ce633c511da54f92b5d8f507351309a3ff4f0229df",
         intel: "7592aa5d74432100bde54226d87663636a4be52c4309e16ec6a61a32c649507b"

  url "https:github.comppyosureleasesdownload#{version}osu.app.#{arch}.zip"
  name "osu!"
  desc "Rhythm game"
  homepage "https:github.comppyosu"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "osu!.app"

  zap trash: [
    "~.localshareosu",
    "~LibrarySaved Application Statesh.ppy.osu.lazer.savedState",
  ]
end