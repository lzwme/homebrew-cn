cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2025.316.0"
  sha256 arm:   "865cd0eb8280b4ecdf25355a37fc0146a3ce02f3da55a43e1bb6a9e81380aee6",
         intel: "6512221e305ab5fb82ead78258cc8d8b35c014a911025992d5bd58df5abcb96f"

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