cask "gnucash" do
  arch arm: "Arm", intel: "Intel"

  version "5.12-2"
  sha256 arm:   "f2e174a64c2e5b3499078d2c15cfb6d041d5cc67adac2d2d5f3bf27582304d60",
         intel: "8e3727cf6958a4ee37f1087edc4eebdfcc0f33405d5e581e73063c5822cff00e"

  url "https://ghfast.top/https://github.com/Gnucash/gnucash/releases/download/#{version.hyphens_to_dots.major_minor}/Gnucash-#{arch}-#{version}.dmg",
      verified: "github.com/Gnucash/gnucash/"
  name "GnuCash"
  desc "Double-entry accounting program"
  homepage "https://www.gnucash.org/"

  livecheck do
    url :url
    regex(/^Gnucash-#{arch}[._-]v?(\d+(?:[.-]\d+)+)\.dmg$/i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  app "Gnucash.app"

  zap trash: [
    "~/Library/Application Support/Gnucash",
    "~/Library/Preferences/org.gnucash.Gnucash.plist",
    "~/Library/Saved Application State/org.gnucash.Gnucash.savedState",
  ]
end