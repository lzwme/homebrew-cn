cask "fantasy-map-generator" do
  on_arm do
    version "1.89.36"
    sha256 :no_check

    url "https:github.comAzgaarFantasy-Map-Generatorreleasesdownloadcurrentfmg-darwin-arm64.zip",
        verified: "github.comAzgaarFantasy-Map-Generator"

    livecheck do
      url :url
      strategy :extract_plist
    end

    app "Azgaars_Fantasy_Map_Generator.app"
  end
  on_intel do
    version "1.3"
    sha256 "6aba1ba5b3c358fe4b09d2cbd7449bc603213cbc52de622250eaabaf8eae6d6d"

    url "https:github.comAzgaarFantasy-Map-Generatorreleasesdownloadv#{version}FMG-macos-x64.dmg",
        verified: "github.comAzgaarFantasy-Map-Generator"

    livecheck do
      skip "Legacy version"
    end

    app "Azgaar's Fantasy Map Generator.app"
  end

  name "Azgaar's Fantasy Map Generator"
  desc "Generate interactive and highly customizable maps"
  homepage "https:azgaar.github.ioFantasy-Map-Generator"

  zap trash: [
    "~LibraryApplication Supportazgaars-fantasy-map-generator-nativefier-2aab42",
    "~LibraryPreferencescom.electron.nativefier.azgaars-fantasy-map-generator-nativefier-2aab42.plist",
  ]
end