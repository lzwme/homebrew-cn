cask "k8studio" do
  arch arm: "-arm64"

  version "3.0.2-beta"
  sha256 arm:   "1295963d5b5fab22346d20cd5920c4c1be0f772f4ba8b16ec09bc8cc31ff4e8e",
         intel: "9ee02bcb9711df5782e73cedd2f65c652fae0fe80770290ea6e6a9fcd50598f7"

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