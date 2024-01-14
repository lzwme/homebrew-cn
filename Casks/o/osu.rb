cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.113.0"
  sha256 arm:   "ae4b726e34f96cdad126ac27e93473b3b65c3885c26d6001d82d0b4d86f42603",
         intel: "818a4b071f575e90ffc47b1ce7e9e1f47a8c5d85157e3660937337b9189474da"

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