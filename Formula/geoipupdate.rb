class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://ghproxy.com/https://github.com/maxmind/geoipupdate/archive/v5.0.3.tar.gz"
  sha256 "1a55aae02f7739f8bc7373316347a8f6c7df85fa51addd7b1f9547b583aad173"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "e739e9d36ab1b24a9b4332a5437f5b10a9be130f89ec79ae0b7a839aea9575b5"
    sha256 arm64_monterey: "f31e2f450012e0557538976de6a6248a4347fd94b1da6ee9e933f6d80898a209"
    sha256 arm64_big_sur:  "5af95c39c820e628d83482319cfda368e6b7c861ce25c7d145e7a061e30f5f4f"
    sha256 ventura:        "e58802955db3c22b565ad085dd61dd8e3f56c474081519927bfbf25533eaae9b"
    sha256 monterey:       "207de8e73b3ff0878d996eabee7a0d21ad6dc76139ad2c563e274ad243253a83"
    sha256 big_sur:        "3d99ae8b1e7ad83102c34e8f11ba96e44059a64ad228252b796947bc7ceb8c86"
    sha256 x86_64_linux:   "7629b6d3aa86a3d4df36c1236645afd695c9d52f81a822b9c8230d53956ed3bd"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP", "VERSION=#{version} (homebrew)"

    bin.install  "build/geoipupdate"
    etc.install  "build/GeoIP.conf"
    man1.install "build/geoipupdate.1"
    man5.install "build/GeoIP.conf.5"
  end

  def post_install
    (var/"GeoIP").mkpath
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end