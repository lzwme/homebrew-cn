cask "dropshare" do
  version "6.5,6095"
  sha256 "8dda141c3fd4073efdab6c5124d589b843ab6246d229400902c45b7e4e47599f"

  url "https://d2wvuuix8c9e48.cloudfront.net/Dropshare#{version.major}-#{version.csv.second}.app.zip",
      verified: "d2wvuuix8c9e48.cloudfront.net/"
  name "Dropshare"
  desc "File sharing solution"
  homepage "https://dropshare.app/"

  livecheck do
    url "https://dropshare.app/sparkle/Dropshare#{version.major}.xml"
    regex(/(\d+(?:\.\d+)+)/i)
    strategy :sparkle do |item, regex|
      "#{item.title[regex, 1]},#{item.version}"
    end
  end

  depends_on macos: ">= :monterey"

  app "Dropshare #{version.major}.app"
  binary "#{appdir}/Dropshare #{version.major}.app/Contents/Resources/ds.sh", target: "ds"

  zap trash: [
    "~/Library/Application Support/Dropshare #{version.major}",
    "~/Library/Caches/net.mkswap.Dropshare#{version.major}",
    "~/Library/Cookies/net.mkswap.Dropshare#{version.major}.binarycookies",
    "~/Library/Logs/Dropshare #{version.major}",
    "~/Library/Preferences/net.mkswap.Dropshare#{version.major}.plist",
  ]
end