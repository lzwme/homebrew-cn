cask "mendeley-reference-manager" do
  version "2.118.0"
  sha256 "cb877f6689ae4e2c05ddc2c096d66d385dcb97461a961f13efd2462db0567948"

  url "https://static.mendeley.com/bin/desktop/mendeley-reference-manager-#{version}-x64.dmg"
  name "Mendeley Reference Manager"
  desc "Research management tool"
  homepage "https://www.mendeley.com/download-reference-manager/macOS/"

  livecheck do
    url "https://static.mendeley.com/bin/desktop/latest-mac.yml"
    strategy :electron_builder
  end

  depends_on macos: ">= :high_sierra"

  app "Mendeley Reference Manager.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.elsevier.mendeley.sfl*",
    "~/Library/Application Support/Mendeley Reference Manager",
    "~/Library/Logs/Mendeley Reference Manager",
    "~/Library/Preferences/com.elsevier.mendeley.plist",
    "~/Library/Saved Application State/com.elsevier.mendeley.savedState",
  ]

  caveats do
    requires_rosetta
  end
end