cask "kicad" do
  version "9.0.1"
  sha256 "783f6d7e408ab65f59c0008f8f0464ad8bb64028b0194979be7280c0af7b0719"

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