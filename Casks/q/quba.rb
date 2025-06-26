cask "quba" do
  version "1.5.0"
  sha256 "9e2b94d73931351982631ceda3783a8ba67793928202054855032038b6499d21"

  url "https:github.comZUGFeRDquba-viewerreleasesdownloadv#{version}Quba-#{version}-universal.dmg",
      verified: "github.comZUGFeRDquba-viewer"
  name "Quba-Viewer"
  desc "Viewer for electronic invoices"
  homepage "https:quba-viewer.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Quba.app"

  zap trash: [
    "~LibraryApplication SupportQuba",
    "~LibraryPreferencesorg.quba-viewer.viewer.plist",
    "~LibrarySaved Application Stateorg.quba-viewer.viewer.savedState",
  ]
end