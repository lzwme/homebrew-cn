cask "eloston-chromium" do
  arch arm: "arm64", intel: "x86_64"

  version "134.0.6998.117-1.1"
  sha256 arm:   "a94b1b7399dc7e9ee547b1dbb81578ea0dbd18fb07bb271cd00f43f9ce76fced",
         intel: "1b89bb4756cb6b80dc7e960d136b7111d97a75b3929f838e16a2e24796684bd8"

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