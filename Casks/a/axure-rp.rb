cask "axure-rp" do
  version "11.0.0.4127"
  sha256 "5ae3bd6bd43a54ac117d2c4db5bbc1ace52d6ab4af2d86fc3fbebea2f5d5d983"

  url "https://axure.cachefly.net/versions/#{version.csv.first.major_minor.dots_to_hyphens}/AxureRP-Setup-#{version.split(".")[3]}.dmg",
      verified: "axure.cachefly.net/"
  name "Axure RP"
  desc "Planning and prototyping tool for developers"
  homepage "https://www.axure.com/"

  livecheck do
    url "https://www.axure.com/release-history"
    regex(/>\s*(?:Version|Axure\s*RP)\s*v?(\d+(?:\.\d+)+)/i)
  end

  depends_on macos: ">= :high_sierra"

  app "Axure RP #{version.major}.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.axure.axurerp#*.sfl*",
    "~/Library/Preferences/com.axure.AxureRP#*.plist",
    "~/Library/Saved Application State/com.axure.AxureRP#*.savedState",
  ]

  caveats do
    requires_rosetta
  end
end