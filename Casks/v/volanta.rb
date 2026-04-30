cask "volanta" do
  version "1.17.4,27c25e2f"
  sha256 "1ccdaebbfbca5490ba1d8980ed56551d455c3c86eb99e340ff841c885ae9b592"

  url "https://cdn.volanta.app/software/volanta-app/#{version.csv.first}-#{version.csv.second}/volanta-#{version.csv.first}.dmg"
  name "Volanta"
  desc "Personal flight tracker"
  homepage "https://volanta.app/"

  livecheck do
    url "https://api.volanta.app/api/v1/ClientUpdate/latest-mac.yml"
    regex(%r{volanta-app/v?(\d+(?:\.\d+)+)[._-](\h+)/}i)
    strategy :electron_builder do |yaml, regex|
      yaml["files"]&.map do |item|
        match = item["url"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  depends_on macos: ">= :monterey"

  app "Volanta.app"

  zap trash: [
    "~/Library/Application Support/Volanta",
    "~/Library/Logs/Volanta",
    "~/Library/Preferences/orbx.volanta.plist",
    "~/Library/Saved Application State/orbx.volanta.savedState",
  ]
end