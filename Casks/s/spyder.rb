cask "spyder" do
  arch arm: "arm64", intel: "x86_64"

  version "6.0.5"
  sha256 arm:   "4f65f5d8083459fe96bd41db3b6677e363f7f3aa6b0a7e192858191715c4bb49",
         intel: "11d01578d2bb5fa636852403f5d52f7e567a07e71ce2a79441920c1538151b80"

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

  uninstall quit:    "org.spyder-ide.Spyder-#{version.major}",
            pkgutil: "org.spyder-ide.Spyder.pkg*",
            delete:  [
              "ApplicationsREQUIRED.app",
              "ApplicationsSpyder #{version.major}.app",
            ]

  zap trash: [
    "~.spyder-py3",
    "~LibraryApplication SupportSpyder",
    "~LibraryCachesSpyder",
    "~LibrarySaved Application Stateorg.spyder-ide.Spyder.savedState",
  ]
end