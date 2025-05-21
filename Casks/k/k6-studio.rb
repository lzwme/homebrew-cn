cask "k6-studio" do
  arch arm: "arm64", intel: "x64"

  version "1.3.0"
  sha256 arm:   "f2f469d03519a8a52ddb5aed07811d970b91a61d48e77f32af9a6359d507442f",
         intel: "6801cc7e5e3c5648edc0cfc27174b1d7a0f94bc5ac485d4da7f08640dccf31cb"

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