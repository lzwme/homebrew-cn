cask "avogadro" do
  arch arm: "-arm64"

  version "1.100.0"
  sha256 arm:   "113e65136b127f66a69baa3f57753a38520c73d5a140320bce899c4944b8d85b",
         intel: "3034eed802576c618d8c7d8073ed61ca02a965182bd7521b3d5eda1c3dc94b83"

  url "https:github.comOpenChemistryavogadrolibsreleasesdownload#{version}Avogadro2-#{version}-Darwin#{arch}.dmg",
      verified: "github.comOpenChemistryavogadrolibs"
  name "Avogadro"
  desc "Molecule editor and visualiser"
  homepage "https:avogadro.cc"

  no_autobump! because: :requires_manual_review

  app "Avogadro2.app"

  zap trash: [
    "~LibraryApplication SupportOpenChemistryAvogadro",
    "~LibraryPreferencesorg.openchemistry.Avogadro.plist",
    "~LibrarySaved Application Statecc.avogadro.savedState",
  ]
end