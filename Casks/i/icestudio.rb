cask "icestudio" do
  arch arm: "arm64", intel: "64"

  on_arm do
    version "0.12"
    sha256 "7a11f5055e11e2e19eab2dae9b4e8e4056938922cda2588f3fdd26ab3e87ae23"
  end
  on_intel do
    version "0.11"
    sha256 "959f55093888b91fa8b6715ecc9d6a4d2494dc814ee2ab717ee825284ba13889"
  end

  url "https:github.comFPGAwarsicestudioreleasesdownloadv#{version}icestudio-#{version}-osx#{arch}.dmg",
      verified: "github.comFPGAwarsicestudio"
  name "icestudio"
  desc "Visual editor for open FPGA board"
  homepage "https:icestudio.io"

  # Upstream has not included intel binaries in the latest version(s)
  livecheck do
    url :url
    regex(^icestudio[._-]v?(\d+(?:\.\d+)+)[._-]osx#{arch}\.dmgi)
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

  app "icestudio.app"

  zap trash: [
    "~.icestudio",
    "~icestudio.log",
    "~LibraryApplication Supporticestudio",
    "~LibraryCachesicestudio",
    "~LibraryPreferencescom.nw-builder.icestudio.plist",
    "~LibrarySaved Application Statecom.nw-builder.icestudio.savedState",
  ]
end