cask "qcad" do
  arch arm: "-arm64"

  on_arm do
    version "3.32.7,12.7-26-qt6"
    sha256 "94a42c73e28c8abc8473249848c95816bd7004eb20c760067f26e2f86702d8fe"
  end
  on_intel do
    version "3.32.7,11-26-qt6"
    sha256 "cd44468530962631d6190109ca0d0c3f01de04275b30072cba2aaead34e47333"
  end

  url "https://www.qcad.org/archives/qcad/qcad-#{version.csv.first}-trial-macos-#{version.csv.second}#{arch}.dmg"
  name "QCAD"
  desc "Free, open source application for computer aided drafting in 2D"
  homepage "https://www.qcad.org/"

  # This only returns the version from the first matching file name link on the
  # download page, as the QCAD Snapshot link (further down the page) use the
  # same file name format as QCAD Professional (what the cask uses) and this
  # can cause issues when the version/suffix differs.
  livecheck do
    url "https://www.qcad.org/en/download"
    regex(/href=.*?qcad[._-]v?(\d+(?:\.\d+)+)[._-]trial[._-]macos[._-](\d+(?:[._-]\d+)+(?:[._-]qt\d+)?)#{arch}\.dmg/i)
    strategy :page_match do |page, regex|
      match = page.match(regex)
      next if match.blank?

      "#{match[1]},#{match[2]}"
    end
  end

  depends_on macos: ">= :monterey"

  app "QCAD.app"

  zap trash: [
    "~/.config/QCAD",
    "~/Library/Preferences/org.qcad.plist",
    "~/Library/Saved Application State/org.qcad.savedState",
  ]
end