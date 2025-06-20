cask "bdash" do
  version "1.17.1"
  sha256 "cfed2bb1437e55d9a5de8e2d7ada1203ead1896f1cd897694b2e1324377c2752"

  url "https:github.combdash-appbdashreleasesdownloadv#{version}Bdash-#{version}-mac.zip"
  name "Bdash"
  desc "Simple SQL Client for lightweight data analysis"
  homepage "https:github.combdash-appbdash"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Bdash.app"

  zap trash: [
    "~.bdash",
    "~LibraryApplication SupportBdash",
    "~LibraryLogsBdash",
    "~LibraryPreferencesio.bdash.plist",
    "~LibrarySaved Application Stateio.bdash.savedState",
  ]

  caveats do
    requires_rosetta
  end
end