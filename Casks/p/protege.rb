cask "protege" do
  version "5.6.6"
  sha256 "dcef7020ea1c42030d35f756ec5375d46fe10558e5e63322ece1044d3897336c"

  url "https:github.comprotegeprojectprotege-distributionreleasesdownloadprotege-#{version}Protege-#{version}-mac.zip",
      verified: "github.comprotegeprojectprotege-distribution"
  name "Protégé"
  desc "Ontology editor"
  homepage "https:protege.stanford.edu"

  no_autobump! because: :requires_manual_review

  app "Protege-#{version}Protégé.app"

  zap trash: [
    "~.Protege",
    "~LibraryPreferencesprotege_preferences.*",
    "~LibrarySaved Application Stateedu.stanford.protege.savedState",
  ]
end