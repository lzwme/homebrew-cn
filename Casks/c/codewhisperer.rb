cask "codewhisperer" do
  version "0.15.1"
  sha256 "7a4426f5a3a27a62dbc0538309eb77ea2936c318bb5f67b1fcdc6dd4af37519d"

  url "https://desktop-release.codewhisperer.us-east-1.amazonaws.com/#{version}/CodeWhisperer.dmg",
      verified: "desktop-release.codewhisperer.us-east-1.amazonaws.com/"
  name "CodeWhisperer for Command Line"
  desc "AI-powered productivity tool for the command-line"
  homepage "https://aws.amazon.com/codewhisperer/"

  livecheck do
    url "https://desktop-release.codewhisperer.us-east-1.amazonaws.com/index.json"
    strategy :json do |json|
      json["versions"].map { |item| item["version"] }
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "CodeWhisperer.app"

  zap trash: [
    "~/Library/Application Support/codewhisperer",
    "~/Library/Caches/com.amazon.codewhisperer",
    "~/Library/LaunchAgents/com.amazon.codewhisperer.launcher.plist",
    "~/Library/Preferences/com.amazon.codewhisperer.plist",
    "~/Library/WebKit/com.amazon.codewhisperer",
  ]
end