cask "k8studio" do
  arch arm: "-arm64"

  version "3.1.0"
  sha256 arm:   "188dff50aa81fad5befa63335384d8a021adbc29229735e6d7870c29ce50cb0a",
         intel: "73ab84fa126b3a450e1483690d255210b349fc3454547d6043aefbcb5565f2bf"

  url "https:github.comk8Studiok8Studioreleasesdownloadv#{version}K8Studio-#{version}#{arch}.dmg",
      verified: "github.comk8Studiok8Studio"
  name "K8studio"
  desc "Kubernetes GUI"
  homepage "https:k8studio.io"

  livecheck do
    url :homepage
    regex(href=.*?k8studio[._-]v?(\d+(?:\.\d+)+(?:[._-]beta)?)\.dmgi)
  end

  depends_on macos: ">= :high_sierra"

  app "K8Studio.app"

  zap trash: [
    "~LibraryApplication SupportK8Studio",
    "~LibraryCacheside.k8studio.io",
    "~LibraryCacheside.k8studio.io.ShipIt",
    "~LibraryCachesk8studio-updater",
    "~LibraryLogsK8Studio",
    "~LibraryPreferenceside.k8studio.io.plist",
    "~LibrarySaved Application Stateide.k8studio.io.savedState",
  ]
end