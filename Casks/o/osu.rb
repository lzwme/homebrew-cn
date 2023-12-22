cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2023.1222.0"
  sha256 arm:   "aca21cb4949cb3abded020ba4e738a15433667ef14300f1e5cf73853cfc7efe1",
         intel: "31f4794ef9f819db164b3c17b6fe411b86b38ab70dffac6614ecac254df3e8f6"

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