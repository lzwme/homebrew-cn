cask "k6-studio" do
  arch arm: "arm64", intel: "x64"

  version "1.2.0"
  sha256  arm:   "8f4cb4bb503a03d87a5c97d62b42563d866955f9728d2905dd5d5e8855beed82",
          intel: "def75d9229876b3fdf9fffea00a160187896d6f5aa42902512b6d1ee299e1568"

  url "https:github.comgrafanak6-studioreleasesdownloadv#{version}k6.Studio-#{version}-#{arch}.dmg",
      verified: "github.comgrafanak6-studio"
  name "k6 Studio"
  desc "Application for generating k6 test scripts"
  homepage "https:grafana.comdocsk6-studio"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "k6 Studio.app"

  zap trash: [
        "~LibraryApplication Supportk6 Studio",
        "~LibraryCachescom.electron.k6-studio",
        "~LibraryCachescom.electron.k6-studio.ShipIt",
        "~LibraryHTTPStoragescom.electron.k6-studio",
        "~LibraryLogsk6 Studio",
        "~LibraryPreferencescom.electron.k6-studio",
        "~LibrarySaved Application Statecom.electron.k6-studio.savedState",
      ],
      rmdir: "~Documentsk6-studio"
end