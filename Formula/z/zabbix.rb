class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable7.0zabbix-7.0.1.tar.gz"
  sha256 "bbc749cefb296ffdf7ff48cfafd41632113f97225c7966f4e043436fcbef8ea1"
  license "AGPL-3.0-only"
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "da21fd536ae8070bea297b69ff366ec9cd6fc0714c284f6c337a20d7e9c16a9a"
    sha256 arm64_ventura:  "a088dc75fb2152d1a4cbe6a14f937f284154ec560f9186013b340f3f943830ba"
    sha256 arm64_monterey: "9cdf115800c1f90c0b123385b29fd55f79eb7e89753e8a285d4a03d3c15785d1"
    sha256 sonoma:         "afb33efd9694caa98097880180a02da2825de65dcc61d9951f25dab47d1704fe"
    sha256 ventura:        "045ed841acf29f3185204b4a9ace49a3ce157b1690c0bf63a55494f7bdb34f1a"
    sha256 monterey:       "5b9fce947f1b4c0b91e3c7cb7cd790eeb90f80e328a8c228c2834bce052dbb8a"
    sha256 x86_64_linux:   "93cb30adfbc7c1fc34706239c609812f50eb89772926292613708f0d4eedc68a"
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