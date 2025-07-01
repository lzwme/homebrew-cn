cask "k6-studio" do
  arch arm: "arm64", intel: "x64"

  version "1.5.0"
  sha256 arm:   "2eafcff3bf934b834a6abf552799f56e9baa775145776e0295e3819ceaf3ab64",
         intel: "1400b84b554898888ba702ec87fe7da51b274d6af9767001daced38d081e0d1d"

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