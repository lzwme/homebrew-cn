cask "creality-print" do
  arch arm: "arm64", intel: "x86_64"

  version "6.1.0.2041"
  sha256 arm:   "6370ad30a08a81998e4e2bed0cfbce0da20163ba5b7c5acb5cca4843f0b258eb",
         intel: "e78e6da2c1e2502c9c3275ba207ac6ce8b34b17cb87b48303453641bbbecc618"

  url "https:github.comCrealityOfficialCrealityPrintreleasesdownloadv#{version.major_minor_patch}CrealityPrint-#{version}-macx-#{arch}-Release.dmg",
      verified: "github.comCrealityOfficialCrealityPrint"
  name "Creality Print"
  desc "Slicer and cloud services for some Creality FDM 3D printers"
  homepage "https:www.creality.compagesdownload-software"

  livecheck do
    url :homepage
    regex(href=.*?Creality[._-]?Print[._-]v?(\d+(?:\.\d+)+)[._-]macx[._-]#{arch}[._-]Release\.dmgi)
  end

  depends_on macos: ">= :catalina"

  app "Creality Print.app"

  zap trash: [
    "~LibraryApplication SupportCreality",
    "~LibraryCachesCreality",
    "~LibrarySaved Application Statecom.creality.crealityprint.savedState",
  ]
end