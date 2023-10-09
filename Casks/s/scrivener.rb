cask "scrivener" do
  version "3.3.3,15931,1013"
  sha256 "c01fbfd30dc99717af75dfac36b21cb397c7bcc034b12368187054b82ec89081"

  url "https://scrivener.s3.amazonaws.com/mac_updates/Scrivener_#{version.csv.third}_#{version.csv.second}.zip",
      verified: "scrivener.s3.amazonaws.com/"
  name "Scrivener"
  desc "Word processing software with a typewriter style"
  homepage "https://www.literatureandlatte.com/scrivener/overview"

  livecheck do
    url "https://www.literatureandlatte.com/downloads/scrivener-#{version.major}.xml"
    regex(/scrivener[._-](\d+(?:\.\d+)?+)[._-]/i)
    strategy :sparkle do |item, regex|
      "#{item.short_version},#{item.version},#{item.url[regex, 1]}"
    end
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Scrivener.app"

  zap trash: [
    "~/Library/Application Support/Scrivener",
    "~/Library/Caches/com.literatureandlatte.scrivener*",
    "~/Library/Preferences/com.literatureandlatte.scrivener*.plist",
  ]
end