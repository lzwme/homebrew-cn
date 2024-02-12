cask "openrefine" do
  version "3.7.9"
  sha256 "ba44cd31d82157a66868f0f004b1617b4d8b14033000945b2f14056ce585a650"

  url "https:github.comOpenRefineOpenRefinereleasesdownload#{version}openrefine-mac-#{version}.dmg",
      verified: "github.comOpenRefineOpenRefine"
  name "OpenRefine"
  desc "Tool for working with messy data (previously Google Refine)"
  homepage "https:openrefine.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "OpenRefine.app"

  zap trash: [
    "~LibraryApplication SupportOpenRefine",
    "~LibrarySaved Application Statecom.google.refine.Refine.savedState",
  ]
end