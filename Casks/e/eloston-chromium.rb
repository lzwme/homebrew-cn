cask "eloston-chromium" do
  arch arm: "arm64", intel: "x86-64"

  on_arm do
    version "120.0.6099.71-1.1,1702605100"
    sha256 "aac8fac0d1ff9d270f74734fe5560f0e3a15a1f676f8cd8b74a23fec20d39fed"
  end
  on_intel do
    version "120.0.6099.71-1.1,1702569961"
    sha256 "424cafdaa96bb08ce7e007d048d35043cd0d364373bbad3e0521c218e7175cfc"
  end

  url "https://ghproxy.com/https://github.com/ungoogled-software/ungoogled-chromium-macos/releases/download/#{version.csv.first}_#{arch}__#{version.csv.second}/ungoogled-chromium_#{version.csv.first}_#{arch}-macos.dmg",
      verified: "github.com/ungoogled-software/ungoogled-chromium-macos/"
  name "Ungoogled Chromium"
  desc "Google Chromium, sans integration with Google"
  homepage "https://ungoogled-software.github.io/ungoogled-chromium-binaries/"

  # Releases are separated by architecture, so we have to check multiple recent
  # releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(/^v?(\d+(?:[.-]\d+)+)(?:[._-]#{arch})?(?:[._-]+?(\d+(?:\.\d+)*))?$/i)
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
    "~/Library/Application Support/Chromium",
    "~/Library/Caches/Chromium",
    "~/Library/Preferences/org.chromium.Chromium.plist",
    "~/Library/Saved Application State/org.chromium.Chromium.savedState",
  ]
end