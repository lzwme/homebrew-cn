cask "protege" do
  version "5.6.5"
  sha256 "34266a1f8b45b366876886e5409081aad28c738f1bfecb6f536cc1b13c5a49bb"

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