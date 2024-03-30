class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https:rakudo.org"
  url "https:github.comrakudorakudoreleasesdownload2024.03rakudo-2024.03.tar.gz"
  sha256 "4104ab6a81ff93111130a871229696d567c4fef6e2daf276afbfbdd2f076bdb8"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "afbd9677789dc8e797f6d8561ccd76c41ca12bc5c75775868d16d749560bdbb6"
    sha256 arm64_ventura:  "120f7ea030c357842d980e0044c120c85bb2a6ad623033338ce5ac1d40d88372"
    sha256 arm64_monterey: "5564a3cff69a9a4d800c121fefccf5183bda424ba9959e12e20853e7c0d0f74f"
    sha256 sonoma:         "4a33cd20b568da6f28c113e3da788d18d15ac7039dd025617bee4b7b842fb749"
    sha256 ventura:        "e39c2986b8b3bb64b51f4f76a25874b74a33cf080973c4236177844ab39ea63e"
    sha256 monterey:       "b2b0109f46bca9f7f2c5248ec891273438be1c8247f875571a2dc68c8058eacc"
    sha256 x86_64_linux:   "5bf3d70f9b5917875cf97490eea1cef8d25b5d6d2ed4a4bec71d632a6ea8065f"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "nqp"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}nqp"
    system "make"
    system "make", "install"
    bin.install "toolsinstall-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end