cask "openrefine" do
  version "3.8.2"
  sha256 "6b168a62ecc5592128565e4f4bc6125879a67c7645b2da1ea25f2136ca7e9293"

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