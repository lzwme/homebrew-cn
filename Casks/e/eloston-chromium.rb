cask "eloston-chromium" do
  arch arm: "arm64", intel: "x86_64"

  version "134.0.6998.165-1.1"
  sha256 arm:   "42b7b51d442b3d0e75d0f1e54b4afc44f844c08192d6980b57958f6285854e8f",
         intel: "7bd6a0a325e6d8a73d2cd69aa49597cd018d265588686635bb2663527341ba31"

  url "https:github.comungoogled-softwareungoogled-chromium-macosreleasesdownload#{version}ungoogled-chromium_#{version}_#{arch}-macos.dmg",
      verified: "github.comungoogled-softwareungoogled-chromium-macos"
  name "Ungoogled Chromium"
  desc "Google Chromium, sans integration with Google"
  homepage "https:ungoogled-software.github.io"

  livecheck do
    url :url
    regex(^v?(\d+(?:[.-]\d+)+)(?:[._-]#{arch})?(?:[._-]+?(\d+(?:\.\d+)*))?$i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1]
    end
  end

  conflicts_with cask: [
    "chromium",
    "freesmug-chromium",
  ]
  depends_on macos: ">= :big_sur"

  app "Chromium.app"

  zap trash: [
    "~LibraryApplication SupportChromium",
    "~LibraryCachesChromium",
    "~LibraryPreferencesorg.chromium.Chromium.plist",
    "~LibrarySaved Application Stateorg.chromium.Chromium.savedState",
  ]
end