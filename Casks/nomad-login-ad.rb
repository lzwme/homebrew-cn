cask "nomad-login-ad" do
  version "1.4.0"
  sha256 :no_check

  url "https:files.nomad.menuNoMAD-Login-AD.pkg"
  name "NoMAD Login AD"
  desc "Login extension to manage local accounts mirroring AD accounts withoud binding"
  homepage "https:nomad.menusupport"

  # https:github.comjamfNoMADLogin-AD

  pkg "NoMAD-Login-AD.pkg"

  uninstall pkgutil: "menu.nomad.login.ad"
end