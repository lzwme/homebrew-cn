cask "openrefine" do
  version "3.9.3"
  sha256 "1742ce53866f03966984f79e53077609825b61f99ae4d1af7916eba2f25a31db"

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