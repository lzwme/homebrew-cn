cask "macfuse" do
  version "4.7.2"
  sha256 "cd85131f1329c3f5d8bc2324bd51cb25dbf38125feb298693f9278f2872f2dd2"

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