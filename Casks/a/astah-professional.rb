cask "astah-professional" do
  version "10.1.0,9ceee1"
  sha256 "4d9c28800d6ccf6c7ff10488e1cc6e856392347a7191feeda7ccf0e305aeb0e0"

  url "https://cdn.change-vision.com/files/astah-professional-#{version.csv.first.dots_to_underscores}-#{version.csv.second}-MacOs.dmg",
      verified: "cdn.change-vision.com/files/"
  name "Change Vision Astah Professional"
  desc "Software modelling tool"
  homepage "https://astah.net/editions/professional"

  livecheck do
    url "https://members.change-vision.com/download/files/astah_professional/latest/mac_pkg"
    regex(/astah[._-]professional[._-]v?(\d+(?:[._]\d+)+)[._-](\h+)[._-]MacOs\.dmg/i)
    strategy :header_match do |headers, regex|
      match = headers["location"]&.match(regex)
      next if match.blank?

      "#{match[1].tr("_", ".")},#{match[2]}"
    end
  end

  depends_on macos: ">= :catalina"

  pkg "astah professional ver #{version.csv.first.dots_to_underscores}.pkg"

  uninstall pkgutil: "com.change-vision.astah.professional"

  zap trash: [
        "~/.astah/professional",
        "~/Library/Saved Application State/com.change-vision.astah.professional.savedState",
      ],
      rmdir: "~/.astah"
end