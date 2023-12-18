cask "thonny-xxl" do
  version "3.3.13"
  sha256 "76acf2edb829c244256d2be773f061585fea79c47fb4e1994ddc546f5e71317c"

  url "https:github.comthonnythonnyreleasesdownloadv#{version}thonny-xxl-#{version}.pkg",
      verified: "github.comthonnythonny"
  name "Thonny (XXL bundle)"
  desc "Python IDE for beginners"
  homepage "https:thonny.org"

  livecheck do
    skip "No reliable way to get version info"
  end

  conflicts_with cask: "thonny"

  pkg "thonny-xxl-#{version}.pkg"

  uninstall quit:    "org.thonny.Thonny",
            pkgutil: "org.thonny.Thonny.component",
            delete:  "ApplicationsThonny.app"

  zap trash: [
    "~LibrarySaved Application Stateorg.thonny.Thonny.savedState",
    "~LibraryThonny",
  ]
end