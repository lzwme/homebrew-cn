cask "eloston-chromium" do
  arch arm: "arm64", intel: "x86-64"

  on_arm do
    version "120.0.6099.129-1.1,1704473311"
    sha256 "4b0e003e08dabadc498d8cf07f7cfbaea282ae3eeb30773080ce503c206b2ec1"
  end
  on_intel do
    version "120.0.6099.129-1.1,1704447342"
    sha256 "895fc268038dec015f19fc78e496577ffa2cd81de56324ca21de134e88f1cd01"
  end

  url "https:github.comungoogled-softwareungoogled-chromium-macosreleasesdownload#{version.csv.first}_#{arch}__#{version.csv.second}ungoogled-chromium_#{version.csv.first}_#{arch}-macos.dmg",
      verified: "github.comungoogled-softwareungoogled-chromium-macos"
  name "Ungoogled Chromium"
  desc "Google Chromium, sans integration with Google"
  homepage "https:ungoogled-software.github.ioungoogled-chromium-binaries"

  # Releases are separated by architecture, so we have to check multiple recent
  # releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^v?(\d+(?:[.-]\d+)+)(?:[._-]#{arch})?(?:[._-]+?(\d+(?:\.\d+)*))?$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        (match.length >= 2) ? "#{match[1]},#{match[2]}" : match[1]
      end
    end
  end

  conflicts_with cask: [
    "chromium",
    "freesmug-chromium",
  ]

  app "Chromium.app"

  zap trash: [
    "~LibraryApplication SupportChromium",
    "~LibraryCachesChromium",
    "~LibraryPreferencesorg.chromium.Chromium.plist",
    "~LibrarySaved Application Stateorg.chromium.Chromium.savedState",
  ]
end