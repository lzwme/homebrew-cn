cask "yes24-ebook" do
  version "1.0.1.15"
  sha256 "ee5bb9be1d947cfd74d263173bbaa62270836950ebe232c41a37cd56601907c1"

  url "https://ebookcdn.yes24.com/UPGRADE/PC_CREMA/mac/#{version}/YES24eBook.dmg"
  name "YES24eBook"
  desc "Crema Ebook reader for Yes24"
  homepage "https://www.yes24.com/Main/default.aspx"

  livecheck do
    url "https://cremaupdate.k-epub.com/sv_update.aspx?usrid=&old=0"
    regex(%r{/v?(\d+(?:\.\d+)+)/YES24eBook\.dmg}i)
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "YES24_eBook.app"

  zap trash: [
    "~/Library/Application Scripts/com.yes24.macEBook",
    "~/Library/Containers/com.yes24.macEBook",
  ]
end