cask "mendeley-reference-manager" do
  version "2.116.0"
  sha256 "72d4e92221e7b980f162941f0883a42b3cd717a3441bf5f9a4eefa337949aabb"

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