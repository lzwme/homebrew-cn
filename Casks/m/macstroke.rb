cask "macstroke" do
  version "2.0.5"
  sha256 "113116367df18a2d3278d9540afdb0476f6b45dd6fbd09a565c9c038bb5e1a88"

  url "https:github.commtjoMacStrokereleasesdownload#{version}MacStroke.zip"
  name "MacStroke"
  desc "Configurable global mouse gestures"
  homepage "https:github.commtjoMacStroke"

  no_autobump! because: :requires_manual_review

  app "MacStroke.app"

  zap trash: [
    "~LibraryApplication Scriptsnet.mtjo.MacStroke.FinderSyncExtension",
    "~LibraryCachesMacStroke",
    "~LibraryCachesnet.mtjo.MacStroke",
    "~LibraryContainersnet.mtjo.MacStroke.FinderSyncExtension",
    "~LibraryCookiesnet.mtjo.MacStroke.binarycookies",
    "~LibraryPreferencesnet.mtjo.MacStroke.plist",
  ]
end