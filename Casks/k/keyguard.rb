cask "keyguard" do
  arch arm: "apple", intel: "intel"

  version "2.9.0,20260428"
  sha256 arm:   "2a70535fd3bceb7811fdd0be13f07c0c472eb84a00acb9ef52c526ad59c0af4f",
         intel: "d4fc04766e1583a19dbddcf5eb5e05f527c057ebd644b8c00ed608d6245e5a24"

  url "https://ghfast.top/https://github.com/AChep/keyguard-app/releases/download/r#{version.csv.second}/Keyguard-#{version.csv.first}-#{arch}.dmg"
  name "Keyguard"
  desc "Client for the Bitwarden platform"
  homepage "https://github.com/AChep/keyguard-app"

  livecheck do
    url :url
    regex(%r{/r?(\d+(?:\.\d+)*)/Keyguard[._-](\d+(?:\.\d+)+)[._-]#{arch}\.dmg}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[2]},#{match[1]}"
      end
    end
  end

  depends_on :macos

  app "keyguard.app"

  zap trash: [
    "~/Library/Application Support/keyguard",
    "~/Library/Saved Application State/com.artemchep.keyguard.savedState",
  ]
end