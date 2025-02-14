cask "openrefine" do
  version "3.9.0"
  sha256 "31b9750de8077ab6fd74571c8d96c9b586ad6580e19af0f679213eec81342518"

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

  caveats do
    requires_rosetta
  end
end