cask "basecamp" do
  arch arm: "_arm64"

  version "3,2.3.6"
  sha256 arm:   "f9145589201f247ee3aa9733a209d2dbf5a9a85bf8aa50143089e7bce81dba56",
         intel: "518bb54f6586a167f47245da68d159ea632747aeb72628c4be89bbe3b671b56e"

  url "https://bc#{version.major}-desktop.s3.amazonaws.com/mac#{arch}/basecamp#{version.major}-#{version.csv.second}.zip",
      verified: "bc3-desktop.s3.amazonaws.com/"
  name "Basecamp"
  desc "All-In-One Toolkit for Working Remotely"
  homepage "https://basecamp.com/help/#{version}/guides/apps/mac"

  livecheck do
    url "https://bc#{version.major}-desktop.s3.amazonaws.com/mac#{arch}/updates.json"
    strategy :page_match do |page|
      minor_version = JSON.parse(page)["version"]
      major_version = page.match(/basecamp(\d)/i)
      next if major_version.blank? || minor_version.blank?

      "#{major_version[1]},#{minor_version}"
    end
  end

  auto_updates true

  app "Basecamp #{version.major}.app"

  zap trash: [
    "~/Library/Application Support/Basecamp*",
    "~/Library/Preferences/com.basecamp.basecamp*.plist",
    "~/Library/Saved Application State/com.basecamp.basecamp*.savedState",
  ]
end