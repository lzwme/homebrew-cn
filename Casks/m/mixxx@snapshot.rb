cask "mixxx@snapshot" do
  arch arm: "arm", intel: "intel"

  sha256 arm:   "2f692d76a3dc1cf1170bf3dbdd53431af7daefd2428d51f36dd33204f67aade4",
         intel: "f4b8ec423d1d302dc56c4b7ba58b64e00c0dd6305135eb5c18ec58a0fefc9fba"

  on_arm do
    version "2.7-alpha-380-g2c6c5874f6"
  end
  on_intel do
    version "2.7-alpha-380-g2c6c5874f6"
  end

  url "https://downloads.mixxx.org/snapshots/main/mixxx-#{version}-macos#{arch}.dmg"
  name "Mixxx"
  desc "Open-source DJ software"
  homepage "https://www.mixxx.org/"

  livecheck do
    url "https://downloads.mixxx.org/snapshots/main/manifest.json"
    strategy :json do |json|
      json.dig("macos-macos#{arch}", "git_describe")
    end
  end

  conflicts_with cask: "mixxx"
  depends_on macos: :big_sur

  app "Mixxx.app"

  zap trash: [
    "~/Library/Application Scripts/org.mixxx.mixxx",
    "~/Library/Containers/org.mixxx.mixxx",
    "~/Music/Mixxx",
  ]
end