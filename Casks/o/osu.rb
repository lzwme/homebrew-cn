cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.312.1"
  sha256 arm:   "589b8f7968e4fb92885f2b068d7e44ece66d3a3e792069755dcc9ddfafba46d8",
         intel: "0bf9a8d0237abed93e18c427371ab101a7a14af6cb22a38b63532185eaee6d0a"

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