cask "protege" do
  version "5.6.4"
  sha256 "d6ecd5ff3218defafacb36466ac1a5b2a11cc349096fef0420a354ec19674c79"

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