cask "macfuse" do
  version "4.8.3"
  sha256 "cf2951ce10d005711734196c43c55922d34ad45f6e0b27b15e345eeab1c92935"

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