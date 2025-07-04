cask "privileges" do
  version "2.4.0"
  sha256 "e18bde3e9c86ff5161e193976c68b29fded2fe91a058ec0c336827166d962989"

  url "https:github.comSAPmacOS-enterprise-privilegesreleasesdownload#{version}Privileges_#{version}.pkg"
  name "Privileges"
  desc "Admin rights switcher"
  homepage "https:github.comSAPmacOS-enterprise-privileges"

  depends_on macos: ">= :big_sur"

  pkg "Privileges_#{version}.pkg"
  binary "#{appdir}Privileges.appContentsMacOSPrivilegesCLI"

  uninstall launchctl: [
              "corp.sap.privileges.agent",
              "corp.sap.privileges.daemon",
              "corp.sap.privileges.watcher",
            ],
            pkgutil:   "corp.sap.privileges.pkg"

  zap trash: [
    "~LibraryApplication Scriptscorp.sap.privileges",
    "~LibraryContainerscorp.sap.privileges",
    "~LibraryGroup Containers*.corp.sap.privileges",
  ]
end