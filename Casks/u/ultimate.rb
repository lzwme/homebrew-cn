cask "ultimate" do
  version "3.0.16.404"
  sha256 :no_check

  url "https://download.epubor.com/epubor_ultimate.zip"
  name "Epubor Ultimate"
  desc "Convert and remove DRM on eBooks"
  homepage "https://www.epubor.com/"

  livecheck do
    url "https://www.epubor.com/ultimate.html"
    regex(/Version:\s*(\d+(?:\.\d+)+)/i)
  end

  disable! date: "2026-09-01", because: :unsigned

  pkg "Ultimate.pkg"

  uninstall pkgutil: "EpuborStudioUltimate2"

  zap trash: [
    "~/.Epubor_Keys",
    "~/.Ultimate",
    "~/EpuborLog",
    "~/Library/Preferences/Ultimate.plist",
    "~/Library/Saved Application State/Ultimate.savedState",
  ]
end