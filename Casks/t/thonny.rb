cask "thonny" do
  version "4.1.6"
  sha256 "06cc85f3f835e80e63062a04581cbfacb97098ae613bc15f5c5e8ba04670d1bb"

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