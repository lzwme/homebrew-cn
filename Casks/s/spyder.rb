cask "spyder" do
  arch arm: "_arm64"

  version "5.5.3"
  sha256 arm:   "028b38a4d02f2186a5a61e0e6cc143643b0cb02bfd4e103b07e7d5af5e74fd9b",
         intel: "38b395abd9c352feb48b5436026685f62aa46849e11969a4e8db08140773ca7b"

  url "https:github.comspyder-idespyderreleasesdownloadv#{version}Spyder#{arch}.dmg",
      verified: "github.comspyder-idespyder"
  name "Spyder"
  desc "Scientific Python IDE"
  homepage "https:www.spyder-ide.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Spyder.app"

  zap trash: [
    "~.spyder-py3",
    "~LibraryApplication SupportSpyder",
    "~LibraryCachesSpyder",
    "~LibrarySaved Application Stateorg.spyder-ide.Spyder.savedState",
  ]
end