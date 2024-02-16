cask "eloston-chromium" do
  arch arm: "arm64", intel: "x86-64"

  version "121.0.6167.184-1.1"
  sha256 arm:   "6279afcf9974abf41b7cf037e06340078d319b00d6ff8ddc15040960ae013167",
         intel: "90e67defda429eaca53d2a4ea6797d50c10eb808a7d91528b4c4fb2f49f9d0db"

  url "https:github.comungoogled-softwareungoogled-chromium-macosreleasesdownload#{version}ungoogled-chromium_#{version}_#{arch}-macos.dmg",
      verified: "github.comungoogled-softwareungoogled-chromium-macos"
  name "Ungoogled Chromium"
  desc "Google Chromium, sans integration with Google"
  homepage "https:ungoogled-software.github.ioungoogled-chromium-binaries"

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
  depends_on macos: ">= :catalina"

  app "Chromium.app"

  zap trash: [
    "~LibraryApplication SupportChromium",
    "~LibraryCachesChromium",
    "~LibraryPreferencesorg.chromium.Chromium.plist",
    "~LibrarySaved Application Stateorg.chromium.Chromium.savedState",
  ]
end