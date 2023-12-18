cask "privileges" do
  version "1.5.4"
  sha256 "6f16af136a928a9e0c233ef7d36db4458588224e676b079ede1b626c8ddba346"

  url "https:github.comSAPmacOS-enterprise-privilegesreleasesdownload#{version}Privileges.zip"
  name "Privileges"
  desc "Admin rights switcher"
  homepage "https:github.comSAPmacOS-enterprise-privileges"

  depends_on macos: ">= :sierra"

  app "Privileges.app"
  binary "#{appdir}Privileges.appContentsResourcesPrivilegesCLI", target: "privileges-cli"

  uninstall delete: [
    "LibraryLaunchDaemonscorp.sap.privileges.helper.plist",
    "LibraryPrivilegedHelperToolscorp.sap.privileges.helper",
  ]

  zap trash: [
    "~LibraryApplication Scriptscorp.sap.privileges",
    "~LibraryContainerscorp.sap.privileges",
  ]
end