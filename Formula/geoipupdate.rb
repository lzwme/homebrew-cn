class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://ghproxy.com/https://github.com/maxmind/geoipupdate/archive/v5.0.2.tar.gz"
  sha256 "d679a7e41ee869536feb4f32ed75e4475facb64b3167378b2af94731806938d1"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "1a9040f35ba4e041ef57ba674b62fc2b7c6b38b3ec4e083bbc0436ffdb6f897c"
    sha256 arm64_monterey: "6df61ab837aaaed5c3f12cb5e63f7573237dc3e9ed94731a3e47999b21328304"
    sha256 arm64_big_sur:  "627ed11da5bb84aeb7c9d08da8b992caf5e56f3366472a675a7a60dd97b36311"
    sha256 ventura:        "d904079b5b06a8d43c575817ebf5cf16adc9ce37bdcb3cf24ec7f2155c045480"
    sha256 monterey:       "d6ca0ea0a65a2e706c2a69e65bb23a9bfa4460a45bdd675cee46ace6dd115fb4"
    sha256 big_sur:        "bc6dda5374a65c38bb7cd889db6110be4e5f493ddf4d10b22ccf1a375eaf3967"
    sha256 x86_64_linux:   "ebd272ade7faf78f2a96cd7898d8ac05e2cb1985c01a7756f0d369a3ce008de3"
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