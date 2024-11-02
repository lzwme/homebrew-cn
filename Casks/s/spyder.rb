cask "spyder" do
  arch arm: "arm64", intel: "x86_64"

  version "6.0.2"
  sha256 arm:   "d4cdb48ff1eb19c4576f8bb8eaa6ed540189d182babf9581ff67fa8216c5ffb3",
         intel: "283a43e25d7c86bcb5a16aaad46142a6a4340b6cd20fd84d81332f6de8d6b3f4"

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