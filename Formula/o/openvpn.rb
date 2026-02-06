class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.19.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.19.tar.gz"
  sha256 "13702526f687c18b2540c1a3f2e189187baaa65211edcf7ff6772fa69f0536cf"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1015ba1a2a197fa49e803bbf6383fb0de43db3e8fca385a416720f96baa49a85"
    sha256 arm64_sequoia: "28cb62b6e548c2e1adb49393800af171a89b63eaf857d2022957190d10dc8bf1"
    sha256 arm64_sonoma:  "8245d32868e6857fc81a7e7c9a1466542a5f3bbb5e9989a17ce1cb1daaf396d6"
    sha256 sonoma:        "a01afa339918512a32b412fdf0a2c95dfc447f1fd3b5171cb1e1527560c9fd7a"
    sha256 arm64_linux:   "e153563d79416e84ac1b02f3a1c326c4f5cfe8c3f6bcc0ff89991c7b2fa185f2"
    sha256 x86_64_linux:  "6814ed071d57a3ae4307ac016d9f84c64cd3960ff686b09c291e6d9de3b07dec"
  end

  depends_on "pkgconf" => :build
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
    system "./configure", "--disable-silent-rules",
                          "--with-crypto-library=openssl",
                          "--enable-pkcs11",
                          *std_configure_args
    inreplace "sample/sample-plugins/Makefile" do |s|
      if OS.mac?
        s.gsub! Superenv.shims_path/"pkg-config", Formula["pkgconf"].opt_bin/"pkg-config"
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