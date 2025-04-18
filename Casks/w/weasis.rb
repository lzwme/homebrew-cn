cask "weasis" do
  arch arm: "aarch64", intel: "x86-64"

  version "4.6.0"
  sha256 arm:   "4b78262ef96c791ad5d8da5471beff2443013c6a4ff90d8f0bc0c658253f402c",
         intel: "e9f89769ae960a43e9deaae2cbfccb47cc355b188a5c38d406dd4550648e9b9e"

  url "https:github.comnroduitWeasisreleasesdownloadv#{version}Weasis-#{version}-#{arch}.pkg",
      verified: "github.comnroduitWeasis"
  name "Weasis"
  desc "Free DICOM viewer for displaying and analyzing medical images"
  homepage "https:weasis.orgenindex.html"

  livecheck do
    url "https:nroduit.github.ioenapireleaseapi.json"
    strategy :json do |json|
      json["version"]&.tr("v", "")
    end
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  pkg "Weasis-#{version}-#{arch}.pkg"

  uninstall pkgutil: [
              "org.weasis.launcher",
              "org.weasis.viewer",
            ],
            delete:  "ApplicationsWeasis.app"

  zap trash: [
    "~.weasis",
    "~LibrarySaved Application Stateorg.weasis.launcher.savedState",
  ]
end