cask "prism" do
  version "10.4.1"
  sha256 "55bba7224263c8fbcabadb6a5b157c36683453bc98a44229f34efef926e19852"

  url "https://cdn.graphpad.com/downloads/prism/#{version.major}/#{version}/InstallPrism#{version.major}.dmg"
  name "GraphPad Prism"
  desc "Statistical analysis and graphing software"
  homepage "https://graphpad.com/"

  # The `osVersion` parameter is required but doesn't seem to have an effect on
  # the version in the appcast. However, we may want to monitor this over time
  # (e.g. when the newest macOS release is higher than the hardcoded version).
  livecheck do
    url "https://licenses.graphpad.com/updates?version=#{version}&configuration=full&platform=Mac&osVersion=14"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Prism #{version.major}.app"

  zap delete: [
        "/Library/Application Support/GraphPad",
        "/Library/GraphPad",
      ],
      trash:  [
        "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.graphpad.prism.sfl*",
        "~/Library/Application Support/GraphPad",
        "~/Library/Caches/com.GraphPad.Prism",
        "~/Library/HTTPStorages/com.GraphPad.Prism",
        "~/Library/Logs/GraphPad",
        "~/Library/Preferences/com.GraphPad.Prism.autocomplete.plist",
        "~/Library/Preferences/com.GraphPad.Prism.plist",
        "~/Library/Saved Application State/com.GraphPad.Prism.savedState",
        "~/Library/WebKit/com.GraphPad.Prism",
      ]
end