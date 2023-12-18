cask "thonny" do
  version "4.1.4"
  sha256 "3acf16c0111fbecf351bd0c9d15e7cc0db06578699dac930ac3f9de19c6b0c8d"

  url "https:github.comthonnythonnyreleasesdownloadv#{version}thonny-#{version}.pkg",
      verified: "github.comthonnythonny"
  name "Thonny"
  desc "Python IDE for beginners"
  homepage "https:thonny.org"

  livecheck do
    url "https:github.comthonnythonnyreleases"
    regex(thonny[._-]?(\d+(?:\.\d+)*)\.pkgi)
    strategy :page_match
  end

  conflicts_with cask: "thonny-xxl"

  pkg "thonny-#{version}.pkg"

  uninstall quit:    "org.thonny.Thonny",
            pkgutil: "org.thonny.Thonny.component",
            delete:  "ApplicationsThonny.app"

  zap trash: [
    "~LibrarySaved Application Stateorg.thonny.Thonny.savedState",
    "~LibraryThonny",
  ]
end