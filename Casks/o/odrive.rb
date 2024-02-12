cask "odrive" do
  version "7387"
  sha256 "3a3d461e39f0dd6d04b773be129e16dc3fd41903494a975f4b21e349a36b808a"

  url "https://d3huse1s6vwzq6.cloudfront.net/odrivesync.#{version}.pkg",
      verified: "d3huse1s6vwzq6.cloudfront.net/"
  name "odrive"
  desc "Tool to make any cloud storage unified, synchronized, shareable, and encrypted"
  homepage "https://www.odrive.com/"

  livecheck do
    url "https://www.odrive.com/downloaddesktop?platform=mac"
    strategy :header_match
  end

  pkg "odrivesync.#{version}.pkg"

  # Should also remove ~/.odrive/bin/ on uninstall, but causes
  # faulty reinstall unless ~/.odrive is removed entirely.
  uninstall quit:    "com.oxygen.odriveapp",
            pkgutil: "com.oxygen.odrive.*"

  zap trash: "~/.odrive"
end