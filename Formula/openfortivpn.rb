class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://ghproxy.com/https://github.com/adrienverge/openfortivpn/archive/v1.20.2.tar.gz"
  sha256 "0f8db4217ac9973f4815a2c18a7ab04d2714deec5f8cb6530b171bae17ae38a6"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_ventura:  "e3a9c691d7a51422a2c35ac6e239fc9ef9304584f91883d9ed0c091dc5c6f1f3"
    sha256 arm64_monterey: "9746608c8ed7ddf5290fad6c8244d01dc7d7c70927066478e0758b008fca21bc"
    sha256 arm64_big_sur:  "41f216f0d00cef883c98c4c316dbd77b57bc78319e733897ceca5526ad8acf60"
    sha256 ventura:        "0db5a930ac0fd64c1e1dc75df5827cb054c52727ea0a631a1f7aab577b21a60b"
    sha256 monterey:       "12d9e8053498c7c2ddb26291e8bf7b9ade07c13a4de4fb87c3b5c84ffdf2bfe6"
    sha256 big_sur:        "a973e13c12003567b92db73d493b7c432ec5bced9a56da6d7ec9b20a9f980bfd"
    sha256 x86_64_linux:   "8ca29df0bae094a16b70de2f3880b7a1eeb81f859399ab22ddd6a908b9d9d0a7"
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