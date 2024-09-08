cask "kicad" do
  version "8.0.5"
  sha256 "3002f00be89c09051857309d5bc5f2ed28ab6004d5f48b7f266793afeafdf6cd"

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