cask "creality-print" do
  arch arm: "arm64", intel: "x86_64"

  version "5.1.6.10470"
  sha256 arm:   "01dfdff70bf35258028f60ce5f835ee216cb884494df90277e4e85db3a3d6a8a",
         intel: "37ccd52b214460e13f643c41c8112afbf3b8dc0aa07eeeb01dcfdadae3060280"

  url "https:github.comCrealityOfficialCrealityPrintreleasesdownloadv#{version.csv.first.major_minor_patch}Creality_Print-v#{version.csv.first}-macx-#{arch}-Release.dmg",
      verified: "github.comCrealityOfficialCrealityPrint"
  name "Creality Print"
  desc "Slicer and cloud services for some Creality FDM 3D printers"
  homepage "https:www.creality.compagesdownload-software"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(Creality[._-]Print[._-]v?(\d+(?:\.\d+)+)[._-]macx[._-]#{arch}[._-]Release\.dmgi)
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

  app "Creality Print.app"

  zap trash: [
    "~LibraryApplication SupportCreality",
    "~LibraryCachesCreality",
    "~LibrarySaved Application Statecom.creality.crealityprint.savedState",
  ]
end