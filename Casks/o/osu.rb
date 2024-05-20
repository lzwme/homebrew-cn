cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.519.1"
  sha256 arm:   "ebb594118cdd5bbfad526d5d2d0019b572f51006c004d62ceeb8a186a6c1977f",
         intel: "b257bf466582efee7e995aad2e3d186cf1a46dcbcbaac32a45e3c7a148516b10"

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