cask "balsamiq-wireframes" do
  version "4.7.5"
  sha256 "aeea6c79a8b651b5d61da3a177e6996df47258df126111efab05557d7f94153d"

  url "https://builds.balsamiq.com/bwd/Balsamiq%20Wireframes%20#{version}.dmg"
  name "Balsamiq Wireframes"
  desc "UI wireframing tool"
  homepage "https://balsamiq.com/"

  livecheck do
    url "https://builds.balsamiq.com/bwd/mac.jsonp"
    regex(/callback\((.+)\)/i)
    strategy :page_match do |page, regex|
      match = page.match(regex)
      next if match.blank?

      json = Homebrew::Livecheck::Strategy::Json.parse_json(match[1])
      json["version"]
    end
  end

  depends_on macos: ">= :catalina"

  app "Balsamiq Wireframes.app"

  zap trash: [
    "~/Library/Caches/BalsamiqMockups#{version.major}.*",
    "~/Library/Preferences/BalsamiqMockups#{version.major}",
    "~/Library/Preferences/BalsamiqMockups#{version.major}.*",
    "~/Library/Saved Application State/BalsamiqMockups#{version.major}.*",
  ]
end