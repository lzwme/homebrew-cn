cask "eloston-chromium" do
  arch arm: "arm64", intel: "x86-64"

  sha256 arm:   "1b2815ba51961767e30a46d210045f222bc536b2e4678925fe919ffc4391c628",
         intel: "08a6d509a51c6056a5775e9ed9d4ba2233378d8fa532bcc917a6371dae017e5c"

  on_arm do
    version "131.0.6778.204-1.1"

    livecheck do
      url :url
      regex(^v?(\d+(?:[.-]\d+)+)(?:[._-]#{arch})?(?:[._-]+?(\d+(?:\.\d+)*))?$i)
      strategy :github_latest do |json, regex|
        match = json["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end
  on_intel do
    version "130.0.6723.116-1.1"

    # Upstream isn't able to provide Intel builds for the time being, so we
    # have to use the `GithubReleases` strategy to check recent releases and
    # identify the latest version with an Intel release asset.
    # TODO: Switch back to one `GithubLatest` `livecheck` block when upstream
    # reliably publishes Intel builds again.
    livecheck do
      url :url
      regex(ungoogled[._-]chromium[._-]v?(\d+(?:[.-]\d+)+)[._-]#{arch}[._-]macos\.dmgi)
      strategy :github_releases do |json, regex|
        json.map do |release|
          next if release["draft"] || release["prerelease"]

          release["assets"]&.map do |asset|
            match = asset["name"]&.match(regex)
            next if match.blank?

            match[1]
          end
        end.flatten
      end
    end
  end

  url "https:github.comungoogled-softwareungoogled-chromium-macosreleasesdownload#{version}ungoogled-chromium_#{version}_#{arch}-macos.dmg",
      verified: "github.comungoogled-softwareungoogled-chromium-macos"
  name "Ungoogled Chromium"
  desc "Google Chromium, sans integration with Google"
  homepage "https:ungoogled-software.github.io"

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