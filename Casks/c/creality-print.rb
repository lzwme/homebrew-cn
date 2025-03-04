cask "creality-print" do
  arch arm: "arm64", intel: "x86_64"

  version "6.0.4.1793"
  sha256 arm:   "61c3d5508db1548515ba57c0bb049dc7d2295aec377c473fb9ec7de593ee8e08",
         intel: "8ede800ba13104e9e68134f1a7f482f3bc7beed6fff8f9f3a37df5def214ed50"

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