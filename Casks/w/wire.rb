cask "wire" do
  version "3.35.4861"
  sha256 "40fc6c94c133d63387d8b71e14e742c950eda726b549f27c1963080088627b85"

  url "https:github.comwireappwire-desktopreleasesdownloadmacos%2F#{version}Wire.pkg",
      verified: "github.comwireappwire-desktop"
  name "Wire"
  desc "Collaboration platform focusing on security"
  homepage "https:wire.com"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(%r{^macos[._-]v?(\d+(?:\.\d+)+)$}i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end.flatten
    end
  end

  pkg "Wire.pkg"

  uninstall signal:  [
              ["TERM", "com.wearezeta.zclient.mac.helper"],
              ["TERM", "com.wearezeta.zclient.mac"],
            ],
            pkgutil: "com.wearezeta.zclient.mac"

  zap trash: "~LibraryContainerscom.wearezeta.zclient.mac"
end