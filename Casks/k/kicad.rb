cask "kicad" do
  version "8.0.9"
  sha256 "865a96ff02e9dc4d5e6d3554d8224b7d780aae7b2975329d911dfe57820ba07a"

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