cask "k8studio" do
  arch arm: "-arm64"

  version "1.0.11-beta"
  sha256 arm:   "77f5e0b4fb2d74070ef9b3a8d55e11fed326e9a4941ae855272a412983bd843b",
         intel: "c78651df1b92abd9a55dfb4c89129d046b04d19cda634759af204c59b102373e"

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