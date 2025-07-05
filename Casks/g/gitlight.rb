cask "gitlight" do
  arch arm: "aarch64", intel: "x64"

  version "0.17.6"
  sha256 arm:   "939c3774cf3ea4e3b8e8b308d16dbdae7e07ee00778125633170c52559c812ce",
         intel: "76714506d4b3f5f1a2e4b5374e67b126b5b1a2e658223355e988806f55b2e845"

  url "https://ghfast.top/https://github.com/colinlienard/gitlight/releases/download/gitlight-v#{version}/GitLight_#{version}_#{arch}.dmg",
      verified: "github.com/colinlienard/gitlight/"
  name "GitLight"
  desc "Desktop notifications for GitHub & GitLab"
  homepage "https://gitlight.app/"

  livecheck do
    url "https://gitlight.app/version/darwin/0.0.0?arch=#{arch}"
    strategy :json do |json|
      json["version"]
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "GitLight.app"

  zap trash: [
    "~/Library/Application Support/app.gitlight",
    "~/Library/Caches/app.gitlight",
    "~/Library/LaunchAgents/GitLight.plist",
    "~/Library/Preferences/app.gitlight.plist",
    "~/Library/Saved Application State/app.gitlight.savedState",
    "~/Library/WebKit/app.gitlight",
  ]
end