cask "cycling74-max" do
  version "8.6.5_241008"
  sha256 "24114a89d66be78e6c4b75440fade95ef8d6265900c18fd2e16447f8f2202788"

  url "https://downloads.cdn.cycling74.com/max8/Max#{version.no_dots}.dmg"
  name "Cycling ‘74 Max"
  name "Ableton Max for Live"
  desc "Flexible space to create your own interactive software"
  homepage "https://cycling74.com/products/max"

  livecheck do
    url "https://auth.cycling74.com/maxversion"
    regex(/^\d{2}(\d{2})-(\d{2})-(\d{2})/i)
    strategy :json do |json, regex|
      id = json["_id"]
      match = json["release_date"]&.match(regex)
      next if id.blank? || match.blank?

      "#{id}_#{match[1]}#{match[2]}#{match[3]}"
    end
  end

  app "Max.app"

  zap trash: [
    "/Users/Shared/Max #{version.major}",
    "~/Documents/Max #{version.major}",
    "~/Library/Application Support/Cycling '74",
    "~/Library/Saved Application State/com.cycling74.Max.savedState",
  ]
end