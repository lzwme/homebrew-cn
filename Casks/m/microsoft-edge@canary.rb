cask "microsoft-edge@canary" do
  version "143.0.3604.0,94e7754a-8d45-41fb-8227-9c7911951767"
  sha256 "c2d56cd20f49a69482b284a1e565f64aa23922adda6d896dda2391407c96a93c"

  url "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/#{version.csv.second}/MicrosoftEdgeCanary-#{version.csv.first}.dmg"
  name "Microsoft Edge Canary"
  desc "Multi-platform web browser"
  homepage "https://www.microsoft.com/en-us/edge/download/insider?form="

  livecheck do
    url "https://go.microsoft.com/fwlink/?linkid=2124603"
    regex(%r{/([^/]+)/MicrosoftEdgeCanary[._-]v?(\d+(?:\.\d+)+)\.dmg}i)
    strategy :header_match do |headers, regex|
      match = headers["location"]&.match(regex)
      next if match.blank?

      "#{match[2]},#{match[1]}"
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Microsoft Edge Canary.app"

  uninstall launchctl: "com.microsoft.EdgeUpdater.wake"

  zap trash: [
        "~/Library/Application Scripts/com.microsoft.edgemac.wdgExtension.Canary",
        "~/Library/Application Support/Microsoft Edge Canary",
        "~/Library/Application Support/Microsoft/EdgeUpdater",
        "~/Library/Caches/com.microsoft.edgemac.Canary",
        "~/Library/Caches/com.microsoft.EdgeUpdater",
        "~/Library/Caches/Microsoft Edge Canary",
        "~/Library/Containers/com.microsoft.edgemac.wdgExtension.Canary",
        "~/Library/HTTPStorages/com.microsoft.edgemac.Canary",
        "~/Library/HTTPStorages/com.microsoft.EdgeUpdater",
        "~/Library/LaunchAgents/com.microsoft.EdgeUpdater.*.plist",
        "~/Library/Microsoft/MicrosoftSoftwareUpdate/Actives/com.microsoft.edgemac.Canary",
        "~/Library/Preferences/com.microsoft.edgemac.Canary.plist",
        "~/Library/Saved Application State/com.microsoft.edgemac.Canary.savedState",
        "~/Library/WebKit/com.microsoft.edgemac.Canary",
      ],
      rmdir: [
        "~/Library/Application Support/Microsoft",
        "~/Library/Microsoft",
      ]
end