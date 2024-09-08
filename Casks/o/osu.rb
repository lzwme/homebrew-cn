cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.906.2"
  sha256 arm:   "041f16d63430148c307fb279ea2c8884a3169433066c9b479dd2e489ba391843",
         intel: "655560cae8f639cf1cdce903a7b57e470317a010c87717eeb08a55c10a583c38"

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