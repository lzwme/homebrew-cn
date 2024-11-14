cask "snes9x" do
  version "1.63"
  sha256 "dce88223b0b373357249bfb604415a379dcba6a996ca254bdeca5b16a8564c69"

  url "https:github.comsnes9xgitsnes9xreleasesdownload#{version}snes9x-#{version}-Mac.zip",
      verified: "github.comsnes9xgitsnes9x"
  name "Snes9x"
  desc "Video game console emulator"
  homepage "https:www.snes9x.com"

  # Releases sometimes don't have a macOS build, so we check multiple
  # recent releases instead of only the "latest" release. NOTE: We should be
  # able to use `strategy :github_latest` or drop livecheck altogether
  # when subsequent releases provide files for macOS again.
  livecheck do
    url :url
    regex(^snes9x[._-]v?(\d+(?:\.\d+)+)[._-]Mac\.zip$i)
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

  depends_on macos: ">= :sierra"

  app "Snes9x.app"

  zap trash: [
    "~LibraryApplication SupportSnes9x",
    "~LibraryPreferencescom.snes9x.macos.snes9x.plist",
    "~LibrarySaved Application Statecom.snes9x.macos.snes9x.savedState",
  ]
end