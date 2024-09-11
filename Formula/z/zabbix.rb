class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable7.0zabbix-7.0.3.tar.gz"
  sha256 "173059f57f11716146da79345e5a6bc52eceee6a5c4410664b8500a955598b2a"
  license "AGPL-3.0-only"
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia:  "05419eedbd39fb40f891b865ee89340f69e71134791b4c242b712c4ee34ace20"
    sha256 arm64_sonoma:   "0b3de39ab674d3979927725bba021617388e5a6dbd5380c38424b86ea90f8fe1"
    sha256 arm64_ventura:  "522086a2d2e729d8c75a371a4df4aaf126fe5362bc26ac243d52e450b1aacf34"
    sha256 arm64_monterey: "c634ae005eb477baf1c6d167962d507be98dd595f5e27889ace990b5bcb2f006"
    sha256 sonoma:         "85a5ee366b9d04b93ab6fee76d5b6b79b214a3c6cf7668f1a53e61b0679a07b1"
    sha256 ventura:        "913f38f6817b20e76012579a0118161f1838972c386408a67bf5fabe87f50b9a"
    sha256 monterey:       "d6c3c0ef5c3854620966ac1960e1b53e8063bfef23b954abe106ae47dbc9c9dd"
    sha256 x86_64_linux:   "2cce851ba3b3dd1082706569f7b892e3b0a28a26eca7448167ae044520ca9c7a"
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