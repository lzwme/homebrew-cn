cask "appium-inspector" do
  version "2024.3.1"
  sha256 "f8b10e1f9788dfeaf3060874fde8fd171e0ed96a1584d7359d17aa6b2ee43bef"

  url "https:github.comappiumappium-inspectorreleasesdownloadv#{version}Appium-Inspector-#{version}-universal-mac.zip"
  name "Appium Inspector GUI"
  desc "GUI inspector for mobile apps"
  homepage "https:github.comappiumappium-inspector"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^Appium.*?mac[._-]v?(\d+(?:\.\d+)+)\.(?:dmg|pkg|zip)$i)
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

  app "Appium Inspector.app"

  zap trash: [
    "~LibraryApplication Supportappium-inspector",
    "~LibraryLogsAppium Inspector",
    "~LibraryPreferencesio.appium.inspector.plist",
    "~LibrarySaved Application Stateio.appium.inspector.savedState",
  ]
end