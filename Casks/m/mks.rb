cask "mks" do
  version "1.7"
  sha256 "5e99acc34113b6974d799a4442682d3b82efc7096fc9a3fef78dc471975d68e8"

  url "https://ghfast.top/https://github.com/x0054/MKS/releases/download/#{version}/MKS.zip"
  name "MKS"
  desc "Mechanical keyboard simulator"
  homepage "https://github.com/x0054/MKS"

  no_autobump! because: :requires_manual_review

  app "MKS.app"

  zap trash: "~/Library/Preferences/com.zynath.MKS.plist"

  caveats do
    requires_rosetta
  end
end