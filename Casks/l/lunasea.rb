cask "lunasea" do
  on_mojave :or_older do
    version "10.2.2"
    sha256 "61ef622b70c31550ec6f700eba1e938c23fb97717344e8876d56e2d856a51be4"
  end
  on_catalina :or_newer do
    version "11.0.0"
    sha256 "fa4ecb5bdf57d6f1326e356e248232040f1b2d0d409ea93ac96dc560eded980c"
  end

  url "https:github.comJagandeepBrarLunaSeareleasesdownloadv#{version}lunasea-macos-amd64.zip",
      verified: "github.comJagandeepBrarLunaSea"
  name "LunaSea"
  desc "Self-hosted controller built using the Flutter framework"
  homepage "https:www.lunasea.app"

  deprecate! date: "2025-04-02", because: :discontinued

  app "LunaSea.app"

  zap trash: [
    "~LibraryApplication Scriptsapp.lunasea.lunasea",
    "~LibraryContainersapp.lunasea.lunasea",
  ]
end