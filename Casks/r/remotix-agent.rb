cask "remotix-agent" do
  version "1.5.19,23333"
  sha256 "87be3d61e5406cd55e3c8ff50567e255379b085d1eeca330899186f7ad96b117"

  url "https://downloads.remotix.com/agent-mac/RemotixAgent-#{version.csv.first}-#{version.csv.second}.pkg",
      verified: "remotix.com/agent-mac/"
  name "Remotix Agent"
  desc "Remote desktop and monitoring solution"
  homepage "https://remotixcloud.com/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-11-01", because: :discontinued

  auto_updates true

  pkg "RemotixAgent-#{version.csv.first}-#{version.csv.second}.pkg"

  uninstall launchctl:  [
              "com.nulana.rxagentmac.daemon",
              "com.nulana.rxagentmac.gui",
              "com.nulana.rxagentmac.rc",
              "com.nulana.rxagentmac.user",
            ],
            quit:       "com.nulana.rxagentmac",
            signal:     [
              ["KILL", "com.nulana.rxagentmac.user"],
              ["KILL", "com.nulana.rxagentmac"],
            ],
            login_item: "Remotix Agent",
            pkgutil:    [
              "com.nulana.rxagentmac",
              "com.nulana.rxagentmac.daemon",
            ],
            delete:     [
              "/Library/LaunchAgents/com.nulana.rxagentmac.user.plist",
              "/Library/LaunchDaemons/com.nulana.rxagentmac.daemon.plist",
            ]

  caveats do
    requires_rosetta
  end
end