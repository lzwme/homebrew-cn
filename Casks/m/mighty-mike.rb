cask "mighty-mike" do
  version "3.0.2"
  sha256 "7643e45f480ef148655ab76790b8fa5b7688f041bf174244f8741e285e6092d9"

  url "https:github.comjorioMightyMikereleasesdownloadv#{version}MightyMike-#{version}-mac.dmg",
      verified: "github.comjorioMightyMike"
  name "Mighty Mike"
  desc "Top-down action game from Pangea Software (a.k.a. Power Pete)"
  homepage "https:jorio.itch.iomightymike"

  no_autobump! because: :requires_manual_review

  app "Mighty Mike.app"
  artifact "Documentation", target: "~LibraryApplication SupportMightyMike"

  zap trash: [
    "~LibraryPreferencesMightyMike",
    "~LibrarySaved Application Stateio.jor.mightymike.savedState",
  ]
end