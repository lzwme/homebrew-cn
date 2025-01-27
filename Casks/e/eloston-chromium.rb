cask "eloston-chromium" do
  arch arm: "arm64", intel: "x86_64"

  version "132.0.6834.110-1.1"
  sha256 arm:   "7cdab8658cccff9a9a0a79ff961a95dd0efee234f9bd1a0e8a7ee297805ea37a",
         intel: "bf71f36d27ed8139379f9303cabba4f125683e967585182cd2812958264058ad"

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