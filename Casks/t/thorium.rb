cask "thorium" do
  arch arm: "-arm64"

  version "3.2.2"
  sha256 arm:   "fdec758191cfa645c9d9e37711286d61702bc558e38bdbacef85278add64f62c",
         intel: "ab7efae6affe8acd71a811a5356734319f82d4517ece8ff7c1cca1be4fa9b914"

  url "https://ghfast.top/https://github.com/edrlab/thorium-reader/releases/download/v#{version.csv.first}/Thorium-#{version.csv.second || version.csv.first}#{arch}.dmg",
      verified: "github.com/edrlab/thorium-reader/"
  name "Thorium Reader"
  desc "Epub reader"
  homepage "https://www.edrlab.org/software/thorium-reader/"

  livecheck do
    url :url
    regex(%r{/v?(\d+(?:\.\d+)+)/Thorium[._-]v?(\d+(?:[.-]\d+)+)#{arch}\.dmg}i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["browser_download_url"]&.match(regex)
          next if match.blank?

          (match[2] == match[1]) ? match[1] : "#{match[1]},#{match[2]}"
        end
      end.flatten
    end
  end

  conflicts_with cask: "alex313031-thorium"
  depends_on macos: ">= :big_sur"

  app "Thorium.app"

  zap trash: [
    "~/Library/Application Support/EDRLab.ThoriumReader",
    "~/Library/Preferences/io.github.edrlab.thorium.plist",
  ]
end