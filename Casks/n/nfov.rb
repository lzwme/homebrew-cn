cask "nfov" do
  version "1.3.1"
  sha256 "a23ef50f243453cec012a2f2a754fb44b3c5e997a0703feabda53235274c1e69"

  url "https://ghfast.top/https://github.com/nrlquaker/nfov/releases/download/v#{version}/nfov-darwin-x64-#{version}.zip"
  name "nfov"
  desc "ASCII / ANSI art viewer"
  homepage "https://github.com/nrlquaker/nfov"

  deprecate! date: "2024-09-08", because: :unmaintained
  disable! date: "2025-09-09", because: :unmaintained

  app "nfov.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.electron.nfov.sfl*",
    "~/Library/Application Support/nfov",
    "~/Library/Logs/nfov",
    "~/Library/Preferences/com.electron.nfov.helper.plist",
    "~/Library/Preferences/com.electron.nfov.plist",
    "~/Library/Saved Application State/com.electron.nfov.savedState",
  ]

  caveats do
    requires_rosetta
  end
end