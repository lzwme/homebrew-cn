cask "citrix-workspace" do
  version "24.02.0.78"
  sha256 "c7d45f7c74cb888e03ead89d0ea378f4c0a86f24730b76b0983315a726a8d10a"

  url "https://downloadplugins.citrix.com/ReceiverUpdates/Prod/Receiver/Mac/CitrixWorkspaceAppUniversal#{version}.pkg"
  name "Citrix Workspace"
  desc "Managed desktop virtualization solution"
  homepage "https://www.citrix.com/"

  livecheck do
    url "https://downloadplugins.citrix.com/ReceiverUpdates/Prod/catalog_macos2.xml"
    strategy :xml do |xml|
      xml.get_elements("//Installers[@name='WorkspaceApp']/Installer/Version").map(&:text)
    end
  end

  depends_on macos: ">= :catalina"

  pkg "CitrixWorkspaceAppUniversal#{version}.pkg"

  uninstall launchctl: [
              "com.citrix.AuthManager_Mac",
              "com.citrix.ctxusbd",
              "com.citrix.CtxWorkspaceHelperDaemon",
              "com.citrix.ctxworkspaceupdater",
              "com.citrix.ReceiverHelper",
              "com.citrix.safariadapter",
              "com.citrix.ServiceRecords",
            ],
            quit:      [
              "Citrix.ServiceRecords",
              "com.citrix.CitrixReceiverLauncher",
              "com.citrix.receiver.nomas",
              "com.citrix.ReceiverHelper",
            ],
            pkgutil:   "com.citrix.ICAClient"

  zap trash: [
    "~/Library/Application Support/Citrix Receiver",
    "~/Library/Application Support/Citrix Workspace",
    "~/Library/Application Support/Citrix",
    "~/Library/Application Support/com.citrix.CitrixReceiverLauncher",
    "~/Library/Application Support/com.citrix.HdxRtcEngine",
    "~/Library/Application Support/com.citrix.receiver*",
    "~/Library/Application Support/com.citrix.ReceiverUpdater",
    "~/Library/Caches/com.citrix.receiver*",
    "~/Library/HTTPStorages/com.citrix.CitrixReceiverLauncher",
    "~/Library/HTTPStorages/com.citrix.receiver*",
    "~/Library/Logs/Citrix Workspace",
    "~/Library/Preferences/com.citrix.AuthManager.plist",
    "~/Library/Preferences/com.citrix.CitrixReceiverLauncher.plist",
    "~/Library/Preferences/com.citrix.HdxRtcEngine.plist",
    "~/Library/Preferences/com.citrix.receiver*.plist",
    "~/Library/Preferences/com.citrix.Receiver*.plist",
    "~/Library/Saved Application State/com.citrix.receiver.nomas.savedState",
    "~/Library/WebKit/com.citrix.receiver.nomas",
  ]
end