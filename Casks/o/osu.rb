cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2025.418.1"
  sha256 arm:   "6f163616459f6f5dc11e6784d30ce5ac44ee29d31d6dcb231b6498eebf82971c",
         intel: "456fb208c08c111f3d43ec2fc56d725d98ab7f0ed7e61064087a0ece76619b05"

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