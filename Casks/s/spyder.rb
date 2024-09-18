cask "spyder" do
  arch arm: "arm64", intel: "x86_64"

  version "6.0.0"
  sha256 arm:   "9d7efa94424e8a799950ed963244288b0cd943a9189fd47451e9a85fd5faa868",
         intel: "57f36b5b71b2d7aa23d67765716cef57cb8fde2fd8c95e49b8aea35748db7663"

  url "https:github.comspyder-idespyderreleasesdownloadv#{version}Spyder-macOS-#{arch}.pkg",
      verified: "github.comspyder-idespyder"
  name "Spyder"
  desc "Scientific Python IDE"
  homepage "https:www.spyder-ide.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  pkg "Spyder-macOS-#{arch}.pkg"

  uninstall quit:    "org.spyder-ide.Spyder",
            pkgutil: "org.spyder-ide.Spyder.pkg*",
            delete:  "ApplicationsSpyder #{version.major}.app"

  zap trash: [
    "~.spyder-py3",
    "~LibraryApplication SupportSpyder",
    "~LibraryCachesSpyder",
    "~LibrarySaved Application Stateorg.spyder-ide.Spyder.savedState",
  ]
end