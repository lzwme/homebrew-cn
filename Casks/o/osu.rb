cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.130.2"
  sha256 arm:   "44a431986a286f6ae28e1775ba521750d148680c305f4d8f2835d3ef426026dd",
         intel: "424739fb514a8760d50321a02df7dfbf5eec4ea68627a4248578c1bed238550f"

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