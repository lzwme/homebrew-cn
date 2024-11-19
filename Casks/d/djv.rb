cask "djv" do
  version "2.0.8"
  sha256 "5df641ad2eb27d2beb35ec6ebb05a1d2a14c2af19b65aee370a1eac6fa5ae056"

  url "https:github.comdarbyjohnstonDJVreleasesdownload#{version}DJV-#{version}-Darwin.dmg",
      verified: "github.comdarbyjohnstonDJV"
  name "DJV Imaging"
  desc "Review software for VFX, animation, and film production"
  homepage "https:darbyjohnston.github.ioDJV"

  deprecate! date: "2024-11-17", because: :unmaintained

  app "DJV#{version.major}.app"

  zap trash: [
        "~DocumentsDJVdjv.log",
        "~LibraryPreferencescom.djv-sourceforge-net-*.plist",
      ],
      rmdir: "~DocumentsDJV"

  caveats do
    requires_rosetta
  end
end