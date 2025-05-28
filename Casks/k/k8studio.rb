cask "k8studio" do
  arch arm: "-arm64"

  version "3.0.5-beta"
  sha256 arm:   "2b9eed3f5f13284e32130eff1774ff602c982b564a49d1e458b5dcdb3464a2b9",
         intel: "b7f6d9e27a5a6337b442f54d449cb034b0304d472f000b31b3fdaef4a7e466b7"

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