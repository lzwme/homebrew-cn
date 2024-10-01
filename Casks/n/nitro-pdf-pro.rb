cask "nitro-pdf-pro" do
  version "14.3"
  sha256 "a2ea9cc10e4ef0154c6d45a16d889daac1adfd9b00cca04886b84dccd993a357"

  url "https://downloads.gonitro.com/macos/Nitro%20PDF%20Pro_#{version}.dmg"
  name "Nitro PDF Pro"
  desc "PDF editing software"
  homepage "https://www.gonitro.com/pdfpen"

  livecheck do
    url "https://www.gonitro.com/product-details/downloads/mac"
    regex(/href=.*Nitro%20PDF%20Pro[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  end

  depends_on macos: ">= :mojave"

  app "Nitro PDF Pro.app"

  zap trash: [
    "~/Library/Application Scripts/com.gonitro.NitroPDFPro.retail",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.gonitro.nitropdfpro.retail.sfl*",
    "~/Library/Containers/com.gonitro.NitroPDFPro.retail",
  ]
end