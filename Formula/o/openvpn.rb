class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.11.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.11.tar.gz"
  sha256 "d60adf413d37e11e6e63531cacf2655906756046b4edffe88a13b9e2fec40d5e"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6e87c01455c9448ec91d0370cb2d5be03aee99fbc5f8ae396864f9c143e340d2"
    sha256 arm64_ventura:  "48202c42e4ff0f2ed3dfe2ab0a4bd78719a79b91dcfe6824bea5a1557974c884"
    sha256 arm64_monterey: "a21ddb80b660312a27432ab6d8c0c257f230c9bd8c056a40b7cf8cbfb98e9ac6"
    sha256 sonoma:         "4a297f3c6bc682d250b00ad267c7a8196826f917fce3d76ca9db31db2c3e8b5f"
    sha256 ventura:        "0c1031dbab041b6f9ced4146ce2fc0b5d8da8e1656589cb79f45a43674f7ae4d"
    sha256 monterey:       "806c0c17ebc29ba413535b5b2cffc91ff706dc57ac4754984b11b43f48800623"
    sha256 x86_64_linux:   "774f8b80710b179158517b952a8886153ba89da93a3d78cb20137f0fe47a2cb3"
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