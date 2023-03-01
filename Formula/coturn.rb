class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://ghproxy.com/https://github.com/coturn/coturn/archive/refs/tags/4.6.1.tar.gz"
  sha256 "8fba86e593ed74adc46e002e925cccff2819745371814f42465fbe717483f1d8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "1dfbdbf3aefad9142ce2edec95d448ff9cd2fed007b52a648f3f1e922fab70e8"
    sha256 arm64_monterey: "2501eebd1bafcb385aa6bd29251d154b5c923784c87153feed01d4c4004f692b"
    sha256 arm64_big_sur:  "58ca95c9237a7214aed41ad8e316d7ce7598dc6b1a0b2760ca351411780bff6a"
    sha256 ventura:        "cab7f10155f0805b455f92951adbd72c909a95157faf0512f9f0c6538e55435c"
    sha256 monterey:       "ce8cce8014048c034e99d04c44f17715dc6c5910a49d35fdb0d5f2f6ce909e78"
    sha256 big_sur:        "58f29be2f2ca8c8fbc24c94b5d78f81e5d70d01ff415444f3922ac04840f2425"
    sha256 x86_64_linux:   "b84409e324a79a3eabdf937aa21369851ae533f2d4dfa7544480757e9bbdca74"
  end

  depends_on "pkg-config" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--includedir=#{include}",
                          "--libdir=#{lib}",
                          "--docdir=#{doc}",
                          "--prefix=#{prefix}"

    system "make", "install"

    man.mkpath
    man1.install Dir["man/man1/*"]
  end

  service do
    run [opt_bin/"turnserver", "-c", etc/"turnserver.conf"]
    keep_alive true
    error_log_path var/"log/coturn.log"
    log_path var/"log/coturn.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end