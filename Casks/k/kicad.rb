cask "kicad" do
  version "8.0.2"
  sha256 "f12fb0e642d3adcb8903df6be32b6a5273d56c53b3eec0ef65972875cf7b2b82"

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