cask "wire" do
  version "3.34.4820"
  sha256 "400f5cbabf63c84a4d76c7e5d5c893451a08f90f3bd084a262d4c65920461e2f"

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