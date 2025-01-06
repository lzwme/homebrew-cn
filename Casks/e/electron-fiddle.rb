cask "electron-fiddle" do
  arch arm: "arm64", intel: "x64"

  version "0.36.5"
  sha256 arm:   "55286767880472dcc3c64cad099104bcd209e07654988990835f22f8d8397dea",
         intel: "c9de36fbb50aec75fabf4958bfbe6c2c09d3a9f52587058a45324d8117c32f09"

  url "https:github.comelectronfiddlereleasesdownloadv#{version}Electron.Fiddle-darwin-#{arch}-#{version}.zip",
      verified: "github.comelectronfiddle"
  name "Electron Fiddle"
  desc "Create and play with small Electron experiments"
  homepage "https:www.electronjs.orgfiddle"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^Electron[._-]Fiddle[._-]darwin[._-]#{arch}[._-]v?(\d+(?:\.\d+)+)\.(?:dmg|pkg|zip)$i)
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

  depends_on macos: ">= :big_sur"

  app "Electron Fiddle.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.electron.fiddle.sfl*",
    "~LibraryApplication SupportElectron Fiddle",
    "~LibraryCachescom.electron.fiddle*",
    "~LibraryCachesfiddle-core",
    "~LibraryHTTPStoragescom.electron.fiddle",
    "~LibraryPreferencescom.electron.fiddle*.plist",
    "~LibrarySaved Application Statecom.electron.fiddle.savedState",
  ]
end