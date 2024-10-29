cask "k8studio" do
  arch arm: "-arm64"

  version "2.0.0"
  sha256 arm:   "0aae3c3328f392057417c0d62e53155929bbef0b73f5ed5d524504bd7a668a06",
         intel: "3e63ffe48ff6b790bfc7c4a58e78486d0c3be7e0d2c97ac80cc4bf85631d9d78"

  url "https:github.comguiquik8Studioreleasesdownloadv#{version}K8Studio-#{version}#{arch}.dmg",
      verified: "github.comguiquik8Studio"
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