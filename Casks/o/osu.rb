cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.1219.2"
  sha256 arm:   "864b5ab790f2b30d7cd6b0959560b6744e1cf484cb596314e2b56350372cd13e",
         intel: "dd0382df32fc413b5a7f113b8cb2a3fb8523ff67ede4f4291a1563d2e2e8bf9f"

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