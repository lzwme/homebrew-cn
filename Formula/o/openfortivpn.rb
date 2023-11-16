class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+TLS VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://ghproxy.com/https://github.com/adrienverge/openfortivpn/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "e03242e1bc39de9d916674a4641830a004309c2fd52f0f23aae2f431924ec4ae"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_sonoma:   "821fe22feeb2023d71104727bc101bad96b77b2e980e848d612e94ea739705da"
    sha256 arm64_ventura:  "b563facf7935cfb3cdf0cf62d5f012be041b54bc6caaffbb686562eec5530467"
    sha256 arm64_monterey: "f3089385c13bfddb24691427df774bcd3728df992cddd07104f8ba8df4ed93e3"
    sha256 sonoma:         "b00ae30a1b1dba63057fede4b15c68036e0ebe001c5d633e34f435c69c365f9b"
    sha256 ventura:        "49ea326a6d542d2940523de1298ed36e27ae9205a4d74e170109614b3be90288"
    sha256 monterey:       "2552cc3b196a3c2db9867cb6bd12bb8288b37a638e2a92b43456935cc2587ab2"
    sha256 x86_64_linux:   "a9fddfe0c49d465a13e5492612ccc2ced64b88e428dc3ab955218a11eee6ba3c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/openfortivpn"
    system "make", "install"
  end

  service do
    run [opt_bin/"openfortivpn", "-c", etc/"openfortivpn/openfortivpn/config"]
    keep_alive true
    require_root true
    log_path var/"log/openfortivpn.log"
    error_log_path var/"log/openfortivpn.log"
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end