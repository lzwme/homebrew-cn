cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2023.1218.1"
  sha256 arm:   "6a061a50c9f6530f6f03f24269ee5e50b81e043630f68a9bfe571bd20aab478f",
         intel: "b9a70e29f4b679c44cab0f0e220a72b3032a7be6d1d9a2d31e3fc3ee3e69f0e8"

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