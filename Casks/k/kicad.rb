cask "kicad" do
  version "8.0.1"
  sha256 "4c715390143ba0a200a4281d0221080fde2340905b91c04609b7a0b55bdbd1f7"

  url "https:github.comKiCadkicad-source-mirrorreleasesdownload#{version}kicad-unified-universal-#{version}.dmg",
      verified: "github.comKiCadkicad-source-mirror"
  name "KiCad"
  desc "Electronics design automation suite"
  homepage "https:kicad.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  suite "KiCad"
  binary "KiCadKiCad.appContentsMacOSdxf2idf"
  binary "KiCadKiCad.appContentsMacOSidf2vrml"
  binary "KiCadKiCad.appContentsMacOSidfcyl"
  binary "KiCadKiCad.appContentsMacOSidfrect"
  binary "KiCadKiCad.appContentsMacOSkicad-cli"
  artifact "demos", target: "LibraryApplication Supportkicaddemos"

  zap trash: [
    "LibraryApplication Supportkicad",
    "~LibraryApplication Supportkicad",
    "~LibraryPreferenceskicad",
    "~LibraryPreferencesorg.kicad-pcb.*",
    "~LibrarySaved Application Stateorg.kicad-pcb.*",
  ]
end