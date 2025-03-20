cask "k6-studio" do
  arch arm: "arm64", intel: "x64"
  folder = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "1.0.1"
  sha256  arm:   "c0a1260d8f9761383aec1644274a78e7160a00fc74470087d6aa61d2965bc493",
          intel: "f848a060ddedeabd4fad7d38a4e72cd77870adbe1b1a328682455c10872b123e"

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