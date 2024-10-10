cask "quba" do
  version "1.4.0"
  sha256 "4a30c194d59fc850650bd007a717745d53dd060e26792642f47e5368f373f1bb"

  url "https:quba-viewer.orgfilesQuba-#{version}-arm64.dmg"
  name "Quba-Viewer"
  desc "Viewer for electronic invoices"
  homepage "https:quba-viewer.org"

  livecheck do
    url "https:github.comZUGFeRDquba-viewer"
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: ">= :high_sierra"

  app "Quba.app"

  zap trash: [
    "~LibraryApplication SupportQuba",
    "~LibraryPreferencesorg.quba-viewer.viewer.plist",
    "~LibrarySaved Application Stateorg.quba-viewer.viewer.savedState",
  ]
end