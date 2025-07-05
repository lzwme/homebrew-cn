cask "nomad-login-ad" do
  version "1.4.0"
  sha256 :no_check

  url "https://files.nomad.menu/NoMAD-Login-AD.pkg"
  name "NoMAD Login AD"
  desc "Login extension to manage local accounts mirroring AD accounts withoud binding"
  homepage "https://nomad.menu/support/"

  # https://github.com/jamf/NoMADLogin-AD

  pkg "NoMAD-Login-AD.pkg"

  uninstall pkgutil: "menu.nomad.login.ad"
end