cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.718.1"
  sha256 arm:   "da32257d4a395ccced1bac21a80bb7bc3633699ec58990c245d34df5d73f8639",
         intel: "8ea488448ccb1a31252eeb8321afb5ccadf6c8a1044015f4d1251f474c8b419c"

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