cask "polkadot-js" do
  version "0.132.1"
  sha256 "4521d91f2ee9bf2df35102ca91bcddba1d46f71dd1901b9dd35725159ee07358"

  url "https:github.compolkadot-jsappsreleasesdownloadv#{version}Polkadot-JS-Apps-mac-#{version}.dmg",
      verified: "github.compolkadot-jsapps"
  name "polkadot{.js}"
  desc "Portal into the Polkadot and Substrate networks"
  homepage "https:polkadot.js.org"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^Polkadot[._-]JS[._-]Apps[._-]mac[._-](\d+(?:\.\d+)*)\.(?:dmg|pkg|zip)$i)
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

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Polkadot-JS Apps.app"

  zap trash: [
    "~LibraryPreferencescom.polkadotjs.polkadotjs-apps.plist",
    "~LibrarySaved Application Statecom.polkadotjs.polkadotjs-apps.savedState",
  ]

  caveats do
    requires_rosetta
  end
end