cask "yes24-ebook" do
  version "1.0.1.18"
  sha256 "784835c281756645bad7fe8a53abef60214bd047a3778a50e2f1133ead871d84"

  url "https://ebookcdn.yes24.com/UPGRADE/PC_CREMA/mac/#{version}/YES24eBook.dmg"
  name "YES24eBook"
  desc "Crema Ebook reader for Yes24"
  homepage "https://www.yes24.com/Main/default.aspx"

  livecheck do
    url "https://cremaupdate.k-epub.com/sv_update.aspx?usrid=&old=0"
    regex(%r{/v?(\d+(?:\.\d+)+)/YES24eBook\.dmg}i)
    strategy :xml do |xml, regex|
      url = xml.elements["//PATH"]&.text&.strip
      match = url.match(regex) if url
      next if match.blank?

      match[1]
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "YES24_eBook.app"

  zap trash: [
    "~/Library/Application Scripts/com.yes24.macEBook",
    "~/Library/Containers/com.yes24.macEBook",
  ]
end