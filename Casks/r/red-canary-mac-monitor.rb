cask "red-canary-mac-monitor" do
  version "1.0.5"
  sha256 "254dc88b26d0b26e2dde2e2936927ca6f21a816616148b79719c9d3e6023d9ac"

  url "https:github.comredcanarycomac-monitorreleasesdownloadv#{version}Red-Canary-Mac-Monitor-GoldCardinal-#{version.tr(".", "-")}.pkg",
      verified: "github.comredcanarycomac-monitor"
  name "Red Canary Mac Monitor"
  desc "Analysis tool for security research and malware triage"
  homepage "https:redcanary.commac-threat-analysis-tool"

  depends_on macos: ">= :ventura"

  pkg "Red-Canary-Mac-Monitor-GoldCardinal-#{version.tr(".", "-")}.pkg"

  # The uninstall script requires user input to remove an installed system
  # extension. It is expected that the uninstall CI will time out and fail.
  uninstall pkgutil: "com.redcanary.agent",
            script:  {
              executable:   "ApplicationsRed Canary Mac Monitor.appContentsSharedSupportuninstall.sh",
              must_succeed: false,
              sudo:         true,
            }

  zap trash: [
    "~LibraryApplication SupportRed Canary Mac Monitor",
    "~LibraryPreferencescom.redcanary.agent.plist",
    "~LibrarySaved Application Statecom.redcanary.agent.savedState",
  ]
end