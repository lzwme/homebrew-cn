cask "tailscale" do
  version "1.56.1"
  sha256 "65def75280a83a20b3601b3f83e7d9b74b7c4fb39e93b85889058f4803bc431f"

  url "https:pkgs.tailscale.comstableTailscale-#{version}-macos.zip"
  name "Tailscale"
  desc "Mesh VPN based on Wireguard"
  homepage "https:tailscale.com"

  livecheck do
    url "https:pkgs.tailscale.comstableappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  conflicts_with formula: "tailscale"
  depends_on macos: ">= :catalina"

  app "Tailscale.app"
  # shim script (https:github.comcaskroomhomebrew-caskissues18809)
  shimscript = "#{staged_path}tailscale.wrapper.sh"
  binary shimscript, target: "tailscale"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}Tailscale.appContentsMacOSTailscale' "$@"
    EOS
  end

  uninstall login_item: "Tailscale",
            quit:       "io.tailscale.ipn.macsys"

  zap trash: [
    "~LibraryTailscale",
    "~LibraryApplication Scripts*.io.tailscale.ipn.macsys",
    "~LibraryApplication Scriptsio.tailscale.ipn.macsys.share-extension",
    "~LibraryApplication Scriptsio.tailscale.ipn.macsys",
    "~LibraryContainersio.tailscale.ipn.macos.network-extension",
    "~LibraryContainersio.tailscale.ipn.macsys.share-extension",
    "~LibraryContainersio.tailscale.ipn.macsys",
    "~LibraryContainersTailscale",
    "~LibraryGroup Containers*.io.tailscale.ipn.macsys",
  ]
end