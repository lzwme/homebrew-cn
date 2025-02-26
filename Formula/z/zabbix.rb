class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable7.2zabbix-7.2.4.tar.gz"
  sha256 "635bc949907ad4ac7102801b22b42f22d6d0e4f8b042d1445902b1dd1a9d0b05"
  license "AGPL-3.0-only"
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "982e255def4cca589ad870f8c1f7d19857a7d6f4a72e83310e507d37d89784a0"
    sha256 arm64_sonoma:  "f8110546261aec6ad9f48efeb277508e9889ba10ecb152b26bde561cb52a049f"
    sha256 arm64_ventura: "012793745e56215ee45eef8a43d53fcf2f92d2604741bfb044f110ad5bec47ec"
    sha256 sonoma:        "21035732b32163212a6eb1c44b52fe96b1e8e000fb2dc2384ced292962334abd"
    sha256 ventura:       "6b0ade3b9dd4c90c8434de6dacc8cb5078a322bca2b5eb629aa375a097eaf459"
    sha256 x86_64_linux:  "f1669f46a669dee7b405b9a12f6a41f169996e53965efc39e3aa84ae441269a7"
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