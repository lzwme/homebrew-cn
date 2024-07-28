cask "inkstitch" do
  version "3.1.0"

  on_big_sur :or_older do
    sha256 "e7b789873d828bac53a632a3acee59791bb971a31e4ec57ae5f49a272c8ccbe9"

    url "https:github.cominkstitchinkstitchreleasesdownloadv#{version}inkstitch-v#{version}-high-sierra-catalina-osx-x86_64.pkg",
        verified: "github.cominkstitchinkstitch"

    pkg "inkstitch-v#{version}-high-sierra-catalina-osx-x86_64.pkg"
  end
  on_monterey :or_newer do
    arch arm: "arm64", intel: "x86_64"

    sha256 arm:   "2c8c85285373245dca11fb1d2e516839b3c5ef0a795bbf93a79f01e4d37e5ef3",
           intel: "08f8d593e0776860cb6721d235a3da3e2cb4559dab0c300964705d66cf26c9a8"

    url "https:github.cominkstitchinkstitchreleasesdownloadv#{version}inkstitch-v#{version}-osx-#{arch}.pkg",
        verified: "github.cominkstitchinkstitch"

    pkg "inkstitch-v#{version}-osx-#{arch}.pkg"
  end

  name "Inkstitch"
  desc "Inkscape extension for machine embroidery design"
  homepage "https:inkstitch.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on cask: "inkscape"
  depends_on macos: ">= :high_sierra"

  preflight do
    # This needs to exist, otherwise the installer gets stuck at a prompt asking the user to run Inkscape first.
    inkscape_extensions = Pathname("~LibraryApplication Supportorg.inkscape.Inkscapeconfiginkscape").expand_path
    inkscape_extensions.mkpath
  end

  uninstall pkgutil: "org.inkstitch.installer",
            delete:  "~LibraryApplication Supportorg.inkscape.Inkscapeconfiginkscapeextensionsinkstitch"

  zap trash: "~LibraryApplication Supportinkstitch",
      rmdir: "~LibraryApplication Supportorg.inkscape.Inkscapeconfiginkscapeextensions"
end