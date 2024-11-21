class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable7.0zabbix-7.0.6.tar.gz"
  sha256 "0d77ce0e384d6d30aa739e59648046aada31a97fcd7d626bd9afa37e420a2dd0"
  license "AGPL-3.0-only"
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "8f97b26129f9d8138d8babca10f0d51d6d94802d77dd9ea521eb30da900350ba"
    sha256 arm64_sonoma:  "14d7933c2d7fdb74ef3a7b1a7b22b3fac215883c4adb0ceb0d7232bf9aef105a"
    sha256 arm64_ventura: "00c449051e963b69380c50ed502e8dccfd9a4804df9c4eda109046f5e6b35ccb"
    sha256 sonoma:        "f919a752bbfe28bc85c391e545b4bda611381ff2fd3f6110b0b8555e14990fb5"
    sha256 ventura:       "45317ff303b350abce62c06d9a880366d2bef47ea1b2456b7d99b072c118f976"
    sha256 x86_64_linux:  "12e3423f3f59a53433703439b7a74b316fcc543598b147557c08468b5752c9ae"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --enable-agent
      --enable-ipv6
      --with-libpcre2
      --sysconfdir=#{pkgetc}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}usr"
    end

    system ".configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system sbin"zabbix_agentd", "--print"
  end
end