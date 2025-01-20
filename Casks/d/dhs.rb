cask "dhs" do
  version "1.5.1"
  sha256 "2740a45344a5e61024abd08a37ea08bc79c349c013b651214f202ad401926f69"

  url "https:github.comobjective-seeDylibHijackScannerreleasesdownloadv1.5.1DHS_#{version.dots_to_underscores}.zip",
      verified: "github.comobjective-see"
  name "Dylib Hijack Scanner"
  desc "Scans for dylib hijacking"
  homepage "https:objective-see.orgproductsdhs.html"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "DHS.app"

  zap trash: [
    "~LibraryPreferencescom.objective-see.DHS.plist",
    "~LibrarySaved Application Statecom.objective-see.DHS.savedState",
  ]
end