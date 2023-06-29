cask "nomad-login-ad" do
  version "1.4.0"
  sha256 "d2077061271399252473350671afcc96b86658a629cca3dba9ab6301d1fede8b"

  url "https://files.nomad.menu/NoMAD-Login-AD.pkg"
  name "NoMAD Login AD"
  desc "Login extension to manage local accounts mirroring AD accounts withoud binding"
  homepage "https://nomad.menu/support/"

  # https://github.com/jamf/NoMADLogin-AD

  pkg "NoMAD-Login-AD.pkg"

  uninstall pkgutil: [
    "menu.nomad.login.ad",
  ]
end