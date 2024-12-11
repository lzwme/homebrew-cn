cask "spyder" do
  arch arm: "arm64", intel: "x86_64"

  version "6.0.3"
  sha256 arm:   "d5d07d27f2cd57c7d8923db74e762a8db2841fd750f98f9ff678992deaffed0a",
         intel: "267e5c1bc154c493fc90037a2f9679ff78b2df297a1fb00a3a6c023645fba67b"

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