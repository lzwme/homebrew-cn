cask "solvespace" do
  version "3.1"
  sha256 "9d546e09ca2c9611dc38260248f35bd217b3e34857108b93e1086708583619a2"

  url "https:github.comsolvespacesolvespacereleasesdownloadv#{version}solvespace.dmg",
      verified: "github.com"
  name "SolveSpace"
  desc "Parametric 2d3d CAD"
  homepage "https:solvespace.comindex.pl"

  app "SolveSpace.app"

  zap trash: [
    "~LibraryPreferencescom.solvespace.plist",
    "~LibrarySaved Application Statecom.solvespace.savedState",
  ]
end