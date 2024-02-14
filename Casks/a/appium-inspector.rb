cask "appium-inspector" do
  version "2024.2.2"
  sha256 "9906cebe24eb0d59458f3fdc19394cedd6e12ae68e1145d36a6fffb0a758a417"

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