cask "weasis" do
  arch arm: "aarch64", intel: "x86-64"

  version "4.6.1"
  sha256 arm:   "b5f80444f07bcd94657ddafe9ab193cd5a945612a6d550f3dc2c591afa7b4915",
         intel: "376c940289c9d9e8b5e55033059afaeb978b1d1c4ea06f8831dfe58ed996673f"

  url "https:github.comnroduitWeasisreleasesdownloadv#{version}Weasis-#{version}-#{arch}.pkg",
      verified: "github.comnroduitWeasis"
  name "Weasis"
  desc "Free DICOM viewer for displaying and analyzing medical images"
  homepage "https:weasis.orgenindex.html"

  livecheck do
    url "https:weasis.orgenapireleaseapi.json"
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