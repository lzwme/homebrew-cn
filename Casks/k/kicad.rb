cask "kicad" do
  version "9.0.2"
  sha256 "4c5e28dd755c86a02f7934682d6ff1797c1c098079c599d5092dd285768c848e"

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
  binary "#{appdir}KiCadKiCad.appContentsMacOSdxf2idf"
  binary "#{appdir}KiCadKiCad.appContentsMacOSidf2vrml"
  binary "#{appdir}KiCadKiCad.appContentsMacOSidfcyl"
  binary "#{appdir}KiCadKiCad.appContentsMacOSidfrect"
  binary "#{appdir}KiCadKiCad.appContentsMacOSkicad-cli"
  artifact "demos", target: "LibraryApplication Supportkicaddemos"

  zap delete: "LibraryApplication Supportkicad",
      trash:  [
        "~LibraryApplication Supportkicad",
        "~LibraryPreferenceskicad",
        "~LibraryPreferencesorg.kicad-pcb.*",
        "~LibrarySaved Application Stateorg.kicad-pcb.*",
      ]
end