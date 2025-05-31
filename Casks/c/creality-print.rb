cask "creality-print" do
  arch arm: "arm64", intel: "x86_64"

  version "6.1.2.2458"
  sha256 arm:   "35f10a4060c20f41f52afc8c3fcd34ad6efeae0ae10bb2600b2e4ea00e08d839",
         intel: "b0b0cf93e84780c82ade95c304cfd40e2edef6f96f99d3086f706bef16f1851b"

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