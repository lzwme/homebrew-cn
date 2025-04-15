cask "privileges" do
  version "2.3.0"
  sha256 "4d9e52989baddd378d54ebbdd35f6f63697655f55a5c0d463a800f77c7f219af"

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