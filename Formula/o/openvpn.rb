class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.7.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.7.tar.gz"
  sha256 "ee9877340b1d8de47eb5b52712c3366855fa6a4a1955bf950c68577bd2039913"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "92d0c26ab0081cdd451966809655bc87ea4c16bff9cdb0c2c34e769d1cabf234"
    sha256 arm64_ventura:  "ea6559e2a85d6ff3ccc283cb3915a55ec37122469fc495a22132b72a8d51ee30"
    sha256 arm64_monterey: "cc61f321fe89981d98c77a85ea42806ca3d1f76fd019c828da7f6bc4fe78b2e2"
    sha256 sonoma:         "c8f6eb8724c3079327a5b71e674f4104b02b4b8cf2628005d0d775619456ffc4"
    sha256 ventura:        "786cc9cac9b74ac59e36fadf42375cc95282f8bccea69dd34917fd325cc03b9d"
    sha256 monterey:       "5c303378e7294421c6a423d8c041e946fe8871fc9af46ca6a1446982b3af5466"
    sha256 x86_64_linux:   "69a4c680c67e936f02112607d0edb284945b7fdd934797da7c7f4825af59c298"
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