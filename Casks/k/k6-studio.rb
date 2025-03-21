cask "k6-studio" do
  arch arm: "arm64", intel: "x64"
  folder = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "1.0.2"
  sha256  arm:   "bc86a6fff6547aca5c8123eb83e830f15279dd3e0efc33610b9113d9dc4c19fd",
          intel: "86bdf7279e5c71ec78fb40bc0af9ec46a5cbf4ba8ab1c3f5685e7ddc37a3a3fd"

  url "https:github.comgrafanak6-studioreleasesdownloadv#{version}k6.Studio-#{version}-#{arch}.dmg",
      verified: "github.comgrafanak6-studio"
  name "k6 Studio"
  desc "Application for generating k6 test scripts"
  homepage "https:grafana.comdocsk6-studio"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "k6 Studio.app"
  binary "#{appdir}k6 Studio.appContentsResources#{folder}k6"

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