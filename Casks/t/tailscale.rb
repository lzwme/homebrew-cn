cask "tailscale" do
  version "1.70.0"
  sha256 "15134284147db110de12a87f33d0b617f02e85b176580fc5e30cdf33468923c9"

  url "https:pkgs.tailscale.comstableTailscale-#{version}-macos.pkg"
  name "Tailscale"
  desc "Mesh VPN based on WireGuard"
  homepage "https:tailscale.com"

  livecheck do
    url "https:pkgs.tailscale.comstableappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  conflicts_with formula: "tailscale"
  depends_on macos: ">= :catalina"

  pkg "Tailscale-#{version}-macos.pkg"
  # shim script (https:github.comcaskroomhomebrew-caskissues18809)
  shimscript = "#{staged_path}tailscale.wrapper.sh"
  binary shimscript, target: "tailscale"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}Tailscale.appContentsMacOSTailscale' "$@"
    EOS
  end

  uninstall quit:       "io.tailscale.ipn.macsys",
            login_item: "Tailscale",
            pkgutil:    "com.tailscale.ipn.macsys"

  zap trash: [
    "~LibraryApplication Scripts*.io.tailscale.ipn.macsys",
    "~LibraryApplication Scriptsio.tailscale.ipn.macsys",
    "~LibraryApplication Scriptsio.tailscale.ipn.macsys.login-item-helper",
    "~LibraryApplication Scriptsio.tailscale.ipn.macsys.share-extension",
    "~LibraryCachesio.tailscale.ipn.macsys",
    "~LibraryContainersio.tailscale.ipn.macos.network-extension",
    "~LibraryContainersio.tailscale.ipn.macsys",
    "~LibraryContainersio.tailscale.ipn.macsys.login-item-helper",
    "~LibraryContainersio.tailscale.ipn.macsys.share-extension",
    "~LibraryContainersTailscale",
    "~LibraryGroup Containers*.io.tailscale.ipn.macsys",
    "~LibraryHTTPStoragesio.tailscale.ipn.macsys",
    "~LibraryPreferencesio.tailscale.ipn.macsys.plist",
    "~LibraryTailscale",
  ]

  caveats do
    kext
    license "https:tailscale.comterms"
  end
end