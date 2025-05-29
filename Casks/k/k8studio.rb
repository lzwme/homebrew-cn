cask "k8studio" do
  arch arm: "-arm64"

  version "3.0.6-beta"
  sha256 arm:   "b5e484414da3f4d0070f31ca048b3d76278de89a510f445c5dd437893cc5becc",
         intel: "4bf9d9294bf2eb2482a0ab3ac49073c1621f19bc6c29690b49da060e3b599a21"

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