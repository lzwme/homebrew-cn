cask "macfuse" do
  version "4.6.1"
  sha256 "d0bce4a3b4a0ee5d3c63ef5f56e2acde1a2ecb3461db5e62e374b811bb0d467f"

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