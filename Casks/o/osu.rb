cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2025.225.0"
  sha256 arm:   "fa097bc2220e283e0e39f310bf9eed6457238711ba137bad190add2c466cc186",
         intel: "52aaa0151be56f355a837e47085af02160451f9491fc0646f6ea434a14f68ea3"

  url "https:github.comppyosureleasesdownload#{version}osu.app.#{arch}.zip"
  name "osu!"
  desc "Rhythm game"
  homepage "https:github.comppyosu"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "osu!.app"

  zap trash: [
    "~.localshareosu",
    "~LibrarySaved Application Statesh.ppy.osu.lazer.savedState",
  ]
end