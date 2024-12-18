cask "thonny" do
  version "4.1.7"
  sha256 "32c7540498b9df038abb286363f2eab13b5ba6a731c3cb3d9e348226762225d9"

  url "https:github.comthonnythonnyreleasesdownloadv#{version}thonny-#{version}.pkg",
      verified: "github.comthonnythonny"
  name "Thonny"
  desc "Python IDE for beginners"
  homepage "https:thonny.org"

  livecheck do
    url :url
    strategy :github_latest
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