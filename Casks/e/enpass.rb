cask "enpass" do
  version "6.11.21.2315"
  sha256 "20bd7cde9939ca8e94df1ff91bf3429c52f9f71cf0baf08c84ff9ac7c92d8bf1"

  url "https://dl.enpass.io/stable/mac/package/#{version}/Enpass.pkg"
  name "Enpass"
  desc "Password and credentials manager"
  homepage "https://www.enpass.io/"

  livecheck do
    url "https://www.enpass.io/download/macos/website/stable"
    strategy :header_match
  end

  depends_on :macos

  pkg "Enpass.pkg"

  uninstall pkgutil: "in.sinew.Enpass-Desktop.App"

  zap trash: [
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/in.sinew.Enpass-Desktop",
    "~/Library/Caches/in.sinew.Enpass-Desktop",
    "~/Library/Preferences/in.sinew.Enpass-Desktop.plist",
    "~/Library/Saved Application State/in.sinew.Enpass-Desktop.savedState",
  ]
end