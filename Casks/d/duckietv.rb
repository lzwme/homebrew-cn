cask "duckietv" do
  version "1.1.5"
  sha256 "9c2f72c011cd477071e51238d5bfa0c202babdd263c1e4ea6b3d4e4605da2907"

  url "https:github.comSchizoDuckieDuckieTVreleasesdownload#{version}DuckieTV-#{version}-OSX-x64.pkg",
      verified: "github.comSchizoDuckieDuckieTV"
  name "duckieTV"
  desc "Tool to track TV shows with semi-automagic torrent integration"
  homepage "https:schizoduckie.github.ioDuckieTV"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^DuckieTV[._-]v?(\d+(?:\.\d+)+)[._-](?:mac|OSX)[._-]x64\.(?:dmg|pkg|zip)$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
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