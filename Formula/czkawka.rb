class Czkawka < Formula
  desc "Multi functional app to find duplicates, empty folders, similar images etc."
  homepage "https://github.com/qarmin/czkawka"
  url "https://ghproxy.com/https://github.com/qarmin/czkawka/releases/download/5.1.0/mac_czkawka_gui"
  sha256 "cef0f89b8dc5d41934ccddd0076346bcfbd4023f5f407e9be71a594c95dd01d7"

  depends_on "gtk4"

  def install
    bin.install Dir["*"]
  end
end