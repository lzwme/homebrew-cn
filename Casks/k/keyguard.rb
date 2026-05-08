cask "keyguard" do
  arch arm: "apple", intel: "intel"

  version "2.10.0,20260507.1"
  sha256 arm:   "3b5b8804384ed3c032480fd5dfd51c772df3a5f3204743a0b13068f991f56df0",
         intel: "39c289be01045b5695bb6c914ba65d83ef1f414c2b86695f9f0987e44561df7c"

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