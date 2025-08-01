cask "devonagent" do
  on_catalina :or_older do
    version "3.11.8"
    sha256 "81809652d8821376d3c6df1b68212c61944ec18a874e1c49a310a535050e36fc"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "3.11.10"
    sha256 "0022f53963cda024f1d8a6093a739323b4b9ef3489ce01d32e8d55590e6659fe"

    livecheck do
      url "https://api.devontechnologies.com/1/apps/sparkle/sparkle.php?id=300005193"
      strategy :sparkle do |items|
        items.map(&:version)
      end
    end
  end

  url "https://download.devontechnologies.com/download/devonagent/#{version}/DEVONagent_Pro.app.zip"
  name "DEVONagent Pro"
  desc "Assistant for efficient web searches"
  homepage "https://www.devontechnologies.com/apps/devonagent"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :mojave"

  app "DEVONagent.app"

  zap trash: [
    "~/Library/Application Scripts/*.devon-technologies.*",
    "~/Library/Application Support/DEVONagent",
    "~/Library/Caches/com.devon-technologies.agent",
    "~/Library/Caches/DEVONagent",
    "~/Library/Caches/TemporaryItems/DEVONagent",
    "~/Library/Containers/com.devon-technologies.get",
    "~/Library/Group Containers/*.devon-technologies.*",
    "~/Library/Group Containers/*.devon-technologies.*",
    "~/Library/HTTPStorages/com.devon-technologies.agent",
    "~/Library/Preferences/com.devon-technologies.agent.plist",
    "~/Library/Scripts/Applications/Safari/*DEVONagent*.scpt",
    "~/Library/WebKit/com.devon-technologies.agent",
  ]
end