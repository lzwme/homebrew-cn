cask "spyder" do
  version "5.5.0"
  sha256 "5a8a17c7eeee4999022ba4f45466349a6232c05c1d4e291acb43fcfc88faef94"

  url "https:github.comspyder-idespyderreleasesdownloadv#{version}Spyder.dmg",
      verified: "github.comspyder-idespyder"
  name "Spyder"
  desc "Scientific Python IDE"
  homepage "https:www.spyder-ide.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Spyder.app"

  zap trash: [
    "~.spyder-py3",
    "~LibraryApplication SupportSpyder",
    "~LibraryCachesSpyder",
    "~LibrarySaved Application Stateorg.spyder-ide.Spyder.savedState",
  ]

  caveats do
    requires_rosetta
  end
end