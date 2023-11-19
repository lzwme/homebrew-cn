class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.8.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.8.tar.gz"
  sha256 "5ede1565c8a6d880100f7f235317a7ee9eea83d5052db5547f13a9e76af7805d"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "87d1d04d2a38a8843d4cc59d5ea3f9bb2d24d2fb6f2edb13bc7e5eee6e0972a8"
    sha256 arm64_ventura:  "7d3b34f4b5b9feaf9235a27bcb5c9da3ff92fc01cf85a0358a54235cabbe41c4"
    sha256 arm64_monterey: "15a5a841305eebf947493a63ad306caea8923a853106b268229762b7c10b5cf8"
    sha256 sonoma:         "3e6843669acd7896896bbf9ae8b550b84e4cd0bd6e86bcd4264776e21e732513"
    sha256 ventura:        "3419a8342f2dcca7b8a6f185e55e9c716cbab81f8e77ad2c3e7791059ef42cd5"
    sha256 monterey:       "e5740345e1e76ce070267fdf970e7c6c3a6e7b68ba63351d79daf30981a56867"
    sha256 x86_64_linux:   "a25b9665e36878d79e2a98820889d56c84871b073252d756c8739109d87907bb"
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