cask "tailscale" do
  version "1.60.0"
  sha256 "7a144bf5ef178dc679cdf09d69d57902ca1b35d5e0e5f9c5b3cddd7df0752b21"

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