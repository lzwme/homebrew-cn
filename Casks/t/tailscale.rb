cask "tailscale" do
  version "1.64.0"
  sha256 "6c2ec57f68d38283fe60c372514535389aae0da34c499f2d7aa7b2231f7dd469"

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

  uninstall quit:       "io.tailscale.ipn.macsys",
            login_item: "Tailscale"

  zap trash: [
    "~LibraryApplication Scripts*.io.tailscale.ipn.macsys",
    "~LibraryApplication Scriptsio.tailscale.ipn.macsys",
    "~LibraryApplication Scriptsio.tailscale.ipn.macsys.share-extension",
    "~LibraryContainersio.tailscale.ipn.macos.network-extension",
    "~LibraryContainersio.tailscale.ipn.macsys",
    "~LibraryContainersio.tailscale.ipn.macsys.share-extension",
    "~LibraryContainersTailscale",
    "~LibraryGroup Containers*.io.tailscale.ipn.macsys",
    "~LibraryTailscale",
  ]
end