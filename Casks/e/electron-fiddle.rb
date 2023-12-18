cask "electron-fiddle" do
  arch arm: "arm64", intel: "x64"

  version "0.35.1"
  sha256 arm:   "b1cd8d42ec157b39b4d564513619adf55bf8cdce673b53f789ff577fc68a7ea6",
         intel: "df2df6b773b78652b8e61f087d81b35d8e078d1a23ee1fe9b0acf2a55e29165a"

  url "https:github.comelectronfiddlereleasesdownloadv#{version}Electron.Fiddle-darwin-#{arch}-#{version}.zip",
      verified: "github.comelectronfiddle"
  name "Electron Fiddle"
  desc "Create and play with small Electron experiments"
  homepage "https:www.electronjs.orgfiddle"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^Electron[._-]Fiddle[._-]darwin[._-](?:x64|arm64)[._-]v?(\d+(?:\.\d+)+)\.(?:dmg|pkg|zip)$i)
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

  app "Electron Fiddle.app"

  zap trash: [
    "~LibraryApplication SupportElectron Fiddle",
    "~LibraryCachescom.electron.fiddle*",
    "~LibraryPreferencescom.electron.fiddle*.plist",
  ]
end