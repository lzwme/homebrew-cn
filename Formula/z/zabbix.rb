class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable7.2zabbix-7.2.9.tar.gz"
  sha256 "aa3ce352da4d2daaa542de3e1dcd06fba82df9a7dcc70e4821a0953f2f1d00e7"
  license "AGPL-3.0-only"
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "03d1c19f3b6024b61c3ef8ee6a4e9ca75d7901e47d1aeaa26db52b1cdcdf3407"
    sha256 arm64_sonoma:  "6fada655349f6ca8cc7157bece053feeb1651ee2d4192b2c332faae356ab2952"
    sha256 arm64_ventura: "266783bf32d313e443582d17db6d38301050faca4883ed660da2387d9a02ee3d"
    sha256 sonoma:        "412f16c955772ae98849b9b50d1523074a137d038244382b03ce4833f05f49cd"
    sha256 ventura:       "2f477b20d7153f2bc0236c8cf0ec32225cee760c56cb0e4845ff9745345fa9c1"
    sha256 arm64_linux:   "fac0296b817c79651a9149a4db98c9ee0ec795eb45a39791c023386c5af7585b"
    sha256 x86_64_linux:  "2ce092fe3ef431cc2babe136cbe40ad703f2e05452589b69b38eda7f60e273b6"
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