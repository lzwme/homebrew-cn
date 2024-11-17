cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.1115.3"
  sha256 arm:   "c3e80650e773cdefc5015c874520f702995c1e432def2dc17cd862004e8cdb70",
         intel: "7bfc3f3401a932f86c3a27634d507709253a87ad20fbdb3b4800d504dc27b356"

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