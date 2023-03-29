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
    sha256 arm64_ventura:  "6fd411a15eca391d29c4c15edfd7627b7a4db33da0901f8f1cbcd708932aab7b"
    sha256 arm64_monterey: "dee93b1a35ee01512db5f7ebed26d04de12a90b468866e55e0e694cd4c698539"
    sha256 arm64_big_sur:  "3232822d867d9d286a90070d4a604f504c91b882f0f4b5bf9f48bdcad5d16d5e"
    sha256 ventura:        "53576ef44876980476eb2bd66a49974a610f063a98abfe303bb9ae6c808f0c55"
    sha256 monterey:       "1e981dcc4d5e1f7617af17b34f31270b2db6b0cd47c95f47f39937723367eda7"
    sha256 big_sur:        "f76799cd39755790a1c0b9c2be54be105776d407bf70335532832e6784c6180f"
    sha256 x86_64_linux:   "459239c70690295cd498c59e41f5616cece0c5db8ca0c4de133735711e71bccb"
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@1.1"
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