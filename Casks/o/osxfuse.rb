cask "osxfuse" do
  version "3.11.2"
  sha256 "0f9fd021810063ded2f9a40347e11961369238af27615842063831568a0860ce"

  url "https:github.comosxfuseosxfusereleasesdownloadosxfuse-#{version}osxfuse-#{version}.dmg",
      verified: "github.comosxfuse"
  name "OSXFUSE"
  desc "File system integration"
  homepage "https:osxfuse.github.io"

  livecheck do
    url :url
    regex(^osxfuse[._-]v?(\d+(?:\.\d+)+)$i)
  end

  pkg "ExtrasFUSE for macOS #{version}.pkg"

  postflight do
    set_ownership ["usrlocalinclude", "usrlocallib"]
  end

  uninstall pkgutil: [
              "com.github.osxfuse.pkg.Core",
              "com.github.osxfuse.pkg.MacFUSE",
              "com.github.osxfuse.pkg.PrefPane",
            ],
            kext:    "com.github.osxfuse.filesystems.osxfuse"

  zap trash: "~LibraryCachescom.github.osxfuse.OSXFUSEPrefPane"

  caveats do
    reboot
    <<~EOS
      `#{token}` has been succeeded by `macfuse` as of version 4.0.0.

      To update to a newer version, do:
        brew uninstall #{token}
        brew install macfuse
    EOS
  end
end