cask "pingnoo" do
  version "2021.04.30-develop"
  sha256 "827db036cdc0535bac5b9a1fcf9de4bdaea54ecd5bded702c127303229f10378"

  url "https://ghfast.top/https://github.com/nedrysoft/pingnoo/releases/download/#{version}/Pingnoo.#{version}.universal.dmg",
      verified: "github.com/nedrysoft/pingnoo/"
  name "pingnoo"
  desc "Open-source cross-platform traceroute/ping analyser"
  homepage "https://www.pingnoo.com/"

  livecheck do
    url :url
    regex(/v?(\d+(?:\.\d+)+-\w+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Pingnoo.app"

  zap trash: [
    "~/Library/Application Support/Nedrysoft",
    "~/Library/Saved Application State/com.nedrysoft.pingnoo.savedState",
  ]
end