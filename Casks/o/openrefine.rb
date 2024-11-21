cask "openrefine" do
  version "3.8.6"
  sha256 "81cef5c09de1ca97ba130924af8a6bc1f7035837c9233e85da6b1f1e4af6caab"

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