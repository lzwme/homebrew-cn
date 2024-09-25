class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable7.0zabbix-7.0.4.tar.gz"
  sha256 "06fdb4d70a8a1fd2012ed01f84d0562a94a46163719f21cb11cb4116b6ffb5c2"
  license "AGPL-3.0-only"
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "092577ccd73c5f95c4ee97a47df953b0ea629711ffb44fc5a11bc2ba0e6dbf3f"
    sha256 arm64_sonoma:  "acbe166691f3ac22d62c53b45f28133bbb00d153761ef81a25c3c37c86b99d53"
    sha256 arm64_ventura: "bf6a2375885e698bb107645aa9c8faaa608e8035e96e6228c21491ff8b6ad961"
    sha256 sonoma:        "c8b9fb3c311ff754ccd55e5c88a478869561311d6d008b13a1b52278b0bc8bae"
    sha256 ventura:       "c507d2514ea1d4045e78707383b1460d8ee6087c15ce87ab87e534b0e6dad0e1"
    sha256 x86_64_linux:  "3ed10534cdce3a4e255c29179d675619d3b126631dc312d1f584b0c3fd0442b3"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --enable-agent
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