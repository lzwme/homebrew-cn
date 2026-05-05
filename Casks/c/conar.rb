cask "conar" do
  arch arm: "arm64", intel: "x64"

  version "0.31.1,2605049zot2d535"
  sha256 arm:   "cf01d407f283228998f34b83f906f46a7ee11687819d01ad3d4971ff174891a9",
         intel: "8080fb073675c78c0986c5e6ce60d463e66e689f6abf8de57bbbbd4af546ec37"

  url "https://download.todesktop.com/25112796k32u7/Conar%20#{version.csv.first}%20-%20Build%20#{version.csv.second}-#{arch}-mac.zip",
      verified: "download.todesktop.com/25112796k32u7/"
  name "Conar"
  desc "AI-powered database and data management tool"
  homepage "https://conar.app/"

  livecheck do
    url "https://download.todesktop.com/25112796k32u7/latest-mac.yml"
    regex(/Conar\s*v?(\d+(?:\.\d+)+)\s*-?\s*(?:Build\s*([a-z\d]+?)[._-])?#{arch}[._-]mac\.zip/i)
    strategy :electron_builder do |yaml, regex|
      yaml["files"]&.map do |item|
        match = item["url"]&.match(regex)
        next if match.blank?

        match[2].present? ? "#{match[1]},#{match[2]}" : match[1]
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Conar.app"

  zap trash: [
    "~/Library/Application Support/Conar",
    "~/Library/Logs/Conar",
    "~/Library/Preferences/com.wannabespace.conar.plist",
    "~/Library/Saved Application State/com.wannabespace.conar.savedState",
  ]
end