cask "inkstitch" do
  version "3.0.1"

  on_sierra :or_older do
    sha256 "7a52e13a01dc74fd3267aa0efb1b0718c2463d88fbcca4c06822ab8065f936d1"

    url "https:github.cominkstitchinkstitchreleasesdownloadv#{version}inkstitch-v#{version}-capitan-catalina-osx.pkg",
        verified: "github.cominkstitchinkstitch"

    pkg "inkstitch-v#{version}-sierra-osx.pkg"
  end
  on_high_sierra :or_newer do
    sha256 "64c5c2a38958b803e988783230169ec965f2aec58f27868d4ccddbf73d93141a"

    url "https:github.cominkstitchinkstitchreleasesdownloadv#{version}inkstitch-v#{version}-osx.pkg",
        verified: "github.cominkstitchinkstitch"

    pkg "inkstitch-v#{version}-osx.pkg"
  end

  name "Inkstitch"
  desc "Inkscape extension for machine embroidery design"
  homepage "https:inkstitch.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on cask: "inkscape"
  depends_on macos: ">= :el_capitan"

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