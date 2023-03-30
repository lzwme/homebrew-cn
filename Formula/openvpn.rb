class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.2.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.2.tar.gz"
  sha256 "42d561a9af150b21bc914e3b7aa09f88013d2ffa6d5ce75a025a3b34caa948d4"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "743e0049294a1f1a5d87b31c17b35b139a6a53014f46f2cbccd5cf449f978b99"
    sha256 arm64_monterey: "a131ed7bfa8143add9557368c0cff435ab80a82abec85e9a8ce523fdf0c0916b"
    sha256 arm64_big_sur:  "5ea6d869e97b981176c8a35f4da68dfb2fc694e262d16ebe3a69fa9fe68a6c2f"
    sha256 ventura:        "7f58b71d8e4b8ba2500154c22eb1d16c2aec1eb274df831b8990abf8eb07b820"
    sha256 monterey:       "25a2dac5914c0d51d8321183b2a0dfd25e95513cbdf409de70b41b7936660c43"
    sha256 big_sur:        "3f2fc836c71118bb425eabe55cfde6a92968a2ee7bb0ca0eeac28c6ba06eefff"
    sha256 x86_64_linux:   "61b0ec8c0140c68319bf6aa61add14e62b014c36c3f598d3e18e1b4fcef6bba8"
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"

  on_linux do
    depends_on "libcap-ng"
    depends_on "libnl"
    depends_on "linux-pam"
    depends_on "net-tools"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-crypto-library=openssl",
                          "--enable-pkcs11",
                          "--prefix=#{prefix}"
    inreplace "sample/sample-plugins/Makefile" do |s|
      if OS.mac?
        s.gsub! Superenv.shims_path/"pkg-config", Formula["pkg-config"].opt_bin/"pkg-config"
      else
        s.gsub! Superenv.shims_path/"ld", "ld"
      end
    end
    system "make", "install"

    inreplace "sample/sample-config-files/openvpn-startup.sh",
              "/etc/openvpn", etc/"openvpn"

    (doc/"samples").install Dir["sample/sample-*"]
    (etc/"openvpn").install doc/"samples/sample-config-files/client.conf"
    (etc/"openvpn").install doc/"samples/sample-config-files/server.conf"

    # We don't use mbedtls, so this file is unnecessary & somewhat confusing.
    rm doc/"README.mbedtls"
  end

  def post_install
    (var/"run/openvpn").mkpath
  end

  service do
    run [opt_sbin/"openvpn", "--config", etc/"openvpn/openvpn.conf"]
    keep_alive true
    require_root true
    working_dir etc/"openvpn"
  end

  test do
    system sbin/"openvpn", "--show-ciphers"
  end
end