cask "creality-print" do
  arch arm: "arm64", intel: "x86_64"

  version "6.0.4.1793"
  sha256 arm:   "919e028270e3e41b01e9b26164d0941256f0f12023315e33fcbc39aae74f2ede",
         intel: "747e7a0e9fbbd16736a3b5c68fba3ae4d1f5f566ce137529df948ea84c012957"

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