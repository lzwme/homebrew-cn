cask "macfuse" do
  version "4.5.0"
  sha256 "9df7257315a9b9a97a9ba3a76011cabed7bc3784515b69fa098f8d81efec726d"

  url "https:github.comosxfuseosxfusereleasesdownloadmacfuse-#{version}macfuse-#{version}.dmg",
      verified: "github.comosxfuseosxfuse"
  name "macFUSE"
  desc "File system integration"
  homepage "https:osxfuse.github.io"

  livecheck do
    url "https:osxfuse.github.ioreleasesCurrentRelease.plist"
    regex(macfuse[._-]v?(\d+(?:\.\d+)+)\.dmgi)
  end

  auto_updates true
  conflicts_with cask: "macfuse-dev"
  depends_on macos: ">= :sierra"

  pkg "ExtrasmacFUSE #{version}.pkg"

  postflight do
    set_ownership ["usrlocalinclude", "usrlocallib"]
  end

  uninstall pkgutil: [
    "io.macfuse.installer.components.core",
    "io.macfuse.installer.components.preferencepane",
  ]

  zap trash: "LibraryPreferencePanesmacFUSE.prefPane"

  caveats do
    kext
  end
end