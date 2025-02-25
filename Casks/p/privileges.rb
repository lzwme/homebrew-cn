cask "privileges" do
  version "2.2.0"
  sha256 "3d02e9249124a0c727ec867595b8221da0464ebf2369091587519e67c3ee6cc7"

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
            ],
            pkgutil:   "corp.sap.privileges.pkg"

  zap trash: [
    "~LibraryApplication Scriptscorp.sap.privileges",
    "~LibraryContainerscorp.sap.privileges",
    "~LibraryGroup Containers*.corp.sap.privileges",
  ]
end