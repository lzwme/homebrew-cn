cask "osu" do
  arch arm: "Apple.Silicon", intel: "Intel"

  version "2024.625.2"
  sha256 arm:   "ef06d61a0a407ffbc370d81672a04d402dbdfaa9a185ae1382b579b14bea46b6",
         intel: "c6c3d04fa8b211d346c60ce1da456a063f9dc343951297e87386597a385e78a6"

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