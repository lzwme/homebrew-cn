cask "k6-studio" do
  arch arm: "arm64", intel: "x64"

  version "1.4.0"
  sha256 arm:   "f2df2d55288505b4ba2a9d36fa3f865e35f4e5e1be68d70de9bb5ffad546523a",
         intel: "edcfd6c5b80fedbb6ccd91da7c246bf2c674ed281a40ae22fb5d46e5cad27dc7"

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