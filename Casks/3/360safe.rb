cask "360safe" do
  version "1.2.6"
  sha256 "bf161080b20bc1550e30d705075088f1f77b35aa88192c32cce25e532e09b6f4"

  url "https://free.360totalsecurity.com/totalsecurity/mac/360ts_mac_#{version}.dmg"
  name "360 Total Security"
  desc "Protection and antivirus security"
  homepage "https://www.360totalsecurity.com/features/360-total-security-mac/"

  disable! date: "2024-12-16", because: :discontinued

  app "360Safe.app"

  caveats do
    requires_rosetta
  end
end