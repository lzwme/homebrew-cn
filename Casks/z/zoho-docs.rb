cask "zoho-docs" do
  version "1.10.2"
  sha256 :no_check

  url "https://files-accl.zohopublic.com/public/docsbin/download/393b1306f04a3078b525b2c637d0a727",
      verified: "files-accl.zohopublic.com/"
  name "Zoho Docs"
  desc "Sync files to/from Zoho Docs"
  homepage "https://www.zoho.com/docs/desktop-sync.html"

  disable! date: "2024-04-03", because: :no_longer_available

  depends_on macos: ">= :high_sierra"

  app "Zoho Docs.app"

  zap trash: [
    "~/.zohodocs",
    "~/Library/Application Scripts/com.zohosync.zohodocs",
    "~/Library/Containers/com.zohosync.zohodocs",
  ]
end