cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.412.1"
  sha256 arm:   "25546ea1899c7d1ed0d2022a7526b38bb5fe3366a078e08460b60b9812bce039",
         intel: "3bdf60100768fafd931a203e437fd2819f53c0252b034c34fc0228d4aba0319b"

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