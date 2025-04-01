cask "fujifilm-x-raw-studio" do
  version "1.26.0,3gikcr31"
  sha256 "ee9c823f3ae33c0f8c1f6edfbf358e58c4e4fb47800710ad6944dcfaf2824cf6"

  url "https://dl.fujifilm-x.com/support/software/x-raw-studio-mac#{version.csv.first.no_dots}-#{version.csv.second}/XRawStudio#{version.csv.first.no_dots}.dmg"
  name "FUJIFILM X RAW STUDIO"
  desc "Convert RAW images captured with Fujifilm cameras"
  homepage "https://fujifilm-x.com/global/products/software/x-raw-studio/"

  livecheck do
    url "https://fujifilm-x.com/global/support/download/software/x-raw-studio/"
    regex(/Mac\s*Version\s*:\s*v?(\d+(?:\.\d+)+)/i)
    strategy :page_match do |page, regex|
      version = page[regex, 1]
      next if version.blank?

      dir = page[%r{href=.*?x-raw-studio-mac(?:\d+)-([^/]+)/XRawStudio(?:\d+)\.dmg}i, 1]
      next if dir.blank?

      "#{version},#{dir}"
    end
  end

  depends_on macos: ">= :big_sur"

  app "FUJIFILM X RAW STUDIO.app"

  zap trash: [
    "~/Library/Application Support/com.fujifilm.denji/X RAW STUDIO",
    "~/Library/Preferences/com.fujifilm.denji.X-RAW-STUDIO.plist",
  ]
end