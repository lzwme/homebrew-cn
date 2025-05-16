cask "spyder" do
  arch arm: "arm64", intel: "x86_64"

  version "6.0.6"
  sha256 arm:   "21dbd2578bde0da18150eb20881f91d3e3310d08f0d9d114bda1258f12711212",
         intel: "ac97d7e650c470913a63a66b7f9f3b888c42725da2811de3b6c4b8fb5e3026fb"

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