cask "osxfuse" do
  version "3.11.2"
  sha256 "0f9fd021810063ded2f9a40347e11961369238af27615842063831568a0860ce"

  url "https://ghfast.top/https://github.com/osxfuse/osxfuse/releases/download/osxfuse-#{version}/osxfuse-#{version}.dmg",
      verified: "github.com/osxfuse/"
  name "OSXFUSE"
  desc "File system integration"
  homepage "https://osxfuse.github.io/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-03-28", because: :discontinued, replacement_cask: "macfuse"

  pkg "Extras/FUSE for macOS #{version}.pkg"

  postflight do
    set_ownership ["/usr/local/include", "/usr/local/lib"]
  end

  uninstall kext:    "com.github.osxfuse.filesystems.osxfuse",
            pkgutil: [
              "com.github.osxfuse.pkg.Core",
              "com.github.osxfuse.pkg.MacFUSE",
              "com.github.osxfuse.pkg.PrefPane",
            ]

  zap trash: "~/Library/Caches/com.github.osxfuse.OSXFUSEPrefPane"

  caveats do
    reboot
  end
end