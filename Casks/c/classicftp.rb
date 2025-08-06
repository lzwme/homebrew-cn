cask "classicftp" do
  version "5.00"
  sha256 :no_check

  url "https://www.nchsoftware.com/classic/classicmaci.zip"
  name "ClassicFTP"
  desc "FTP File Transfer Software"
  homepage "https://www.nchsoftware.com/classic/index.html"

  livecheck do
    url "https://www.nchsoftware.com/classic/versions.html"
    regex(/Version\s+v?(\d+(?:\.\d+)+)[^>]*>\s*macOS/im)
  end

  app "ClassicFTP.app"

  zap trash: [
    "~/Library/Application Support/ClassicFTP",
    "~/Library/Preferences/com.nchsoftware.classicftp.plist",
  ]

  caveats do
    requires_rosetta
  end
end