cask "duckietv" do
  version "1.1.5"
  sha256 "9c2f72c011cd477071e51238d5bfa0c202babdd263c1e4ea6b3d4e4605da2907"

  url "https:github.comSchizoDuckieDuckieTVreleasesdownload#{version}DuckieTV-#{version}-OSX-x64.pkg",
      verified: "github.comSchizoDuckieDuckieTV"
  name "duckieTV"
  desc "Tool to track TV shows with semi-automagic torrent integration"
  homepage "https:schizoduckie.github.ioDuckieTV"

  livecheck do
    skip "No reliable way to get version info"
  end

  pkg "DuckieTV-#{version}-OSX-x64.pkg"

  uninstall pkgutil: "tv.duckie.base.pkg",
            delete:  [
              "ApplicationsduckieTV.app",
              "~LibraryApplication SupportDuckieTV-Standalone",
            ]

  caveats do
    requires_rosetta
  end
end