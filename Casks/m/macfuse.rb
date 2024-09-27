cask "macfuse" do
  version "4.8.2"
  sha256 "3c05fbb796082099fa7f28edcfbdadd715578782e199c1c67e46a4b21b72886f"

  url "https:github.comosxfuseosxfusereleasesdownloadmacfuse-#{version}macfuse-#{version}.dmg",
      verified: "github.comosxfuseosxfuse"
  name "macFUSE"
  desc "File system integration"
  homepage "https:osxfuse.github.io"

  livecheck do
    url "https:osxfuse.github.ioreleasesCurrentRelease.plist"
    strategy :xml do |xml|
      xml.get_elements("key[text()='Version']").map { |item| item.next_element&.text&.strip }
    end
  end

  auto_updates true
  conflicts_with cask: "macfuse@dev"
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