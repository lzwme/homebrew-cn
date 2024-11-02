cask "quba" do
  version "1.4.2"
  sha256 "abbbdad83f404f40683e17e4b9bfd1150c46c85d76b856820e9498231b25a8c7"

  url "https:github.comZUGFeRDquba-viewerreleasesdownloadv#{version}Quba-#{version}-universal.dmg",
      verified: "github.comZUGFeRDquba-viewer"
  name "Quba-Viewer"
  desc "Viewer for electronic invoices"
  homepage "https:quba-viewer.org"

  livecheck do
    url :url
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