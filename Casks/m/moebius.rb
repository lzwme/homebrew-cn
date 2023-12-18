cask "moebius" do
  version "1.0.29"
  sha256 "014e355767fa27796a6f5f5778b608a3a802ba064655c23776fa89f0dd1163ba"

  url "https:github.comblocktronicsmoebiusreleasesdownload#{version}Moebius.dmg",
      verified: "github.comblocktronicsmoebius"
  name "Moebius"
  desc "ANSI editor"
  homepage "https:blocktronics.github.iomoebius"

  app "Moebius.app"

  zap trash: [
    "~LibraryApplication SupportMoebius",
    "~LibraryPreferencesorg.andyherbert.moebius.plist",
  ]
end