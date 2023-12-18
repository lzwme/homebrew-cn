cask "protege" do
  version "5.6.3"
  sha256 "c525aec3022feb83b389314114d095061570617f85359cc8a085a65d6e28773f"

  url "https:github.comprotegeprojectprotege-distributionreleasesdownloadprotege-#{version}Protege-#{version}-mac.zip",
      verified: "github.comprotegeprojectprotege-distribution"
  name "Protégé"
  desc "Ontology editor"
  homepage "https:protege.stanford.edu"

  app "Protege-#{version}Protégé.app"

  zap trash: [
    "~.Protege",
    "~LibraryPreferencesprotege_preferences.*",
    "~LibrarySaved Application Stateedu.stanford.protege.savedState",
  ]
end