class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable7.0zabbix-7.0.5.tar.gz"
  sha256 "215301b6e089a685a2fabcca17fc65e5766d42d2079174b65a1bf28df7679692"
  license "AGPL-3.0-only"
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "cb3db87c856cb4f1e167beeebb9341e3d81b558fba305f5b80e2379e4e0565af"
    sha256 arm64_sonoma:  "749292c626d9b1c90166810dcd57270730dc2cb949bb28ab8f9b8a09d1b2adc0"
    sha256 arm64_ventura: "20634e289f17bbb6788c3c100f3f4019b1ad31909d5c0dd8b36836dc5421934d"
    sha256 sonoma:        "77e0422ff7af80053847cda11b33566fa45bfe0e145fbd2590a3c941467c2a4d"
    sha256 ventura:       "5e42058d52bd1d14cc1f85730ef54225bed71f9d1f0813a01db92f53324a27df"
    sha256 x86_64_linux:  "d851e1afd7362e58ddb489d06f7990aafd7acc1ead3fa4758a3ebc964a8c4be2"
  end

  depends_on "pkg-config" => :build
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