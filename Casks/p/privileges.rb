cask "privileges" do
  version "2.0.0"
  sha256 "99cf00557e4965ed949a41665d22211d778ae0b8601e9647970c38e2c48b866f"

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