cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.521.2"
  sha256 arm:   "a95b2b2378a5ac71371299a16c41de5a3da080b5c77d2bfba377c0b77ec1e8fe",
         intel: "47b3d8323af75880def450afac56a164edb3b00fcdb766784b2ef9db7c89b210"

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