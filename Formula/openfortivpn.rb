class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://ghproxy.com/https://github.com/adrienverge/openfortivpn/archive/v1.20.4.tar.gz"
  sha256 "af4b729baa60897a566c920bf34c9ed927eefe14909d13a980a25c8ae91f144f"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_ventura:  "944cda910a5891b4ba18904a5af4313dda5ac56f76c231e4e70c8beab33f521b"
    sha256 arm64_monterey: "5f9d340df390d1640552b26712a3f08e799a2ab38234f857245052d7cea0aa07"
    sha256 arm64_big_sur:  "53815d846684cdb080cda1ee664a440e360076d5cb6c0297f19cb564f65a7f34"
    sha256 ventura:        "e9df03637546a2cf081b460a91d2593506216a21191aa01cb1e7b21b262ff9ce"
    sha256 monterey:       "4cd5ec972ed8a53fc4a1ef92d8ebfa8607fd1ca6dc4970cdaeb9cad8e7f5fa78"
    sha256 big_sur:        "4187c239383284112e7e0e8ea334ba8829c65f72d0d948f5c6dc6097965fb810"
    sha256 x86_64_linux:   "a3f3d30734cc144e15338d758b3d2fb9f00125608894200f2ef178aaec4e41cc"
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