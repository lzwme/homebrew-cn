class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable7.2zabbix-7.2.10.tar.gz"
  sha256 "512f933faaad093dcb96710b591f77b7b9dff00d58d7144f23edf4d06035bfc8"
  license "AGPL-3.0-only"
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "fc5d4d0e77b1477a20003ab763c42b6bbaa55b46219722a00253715bf85a8afe"
    sha256 arm64_sonoma:  "fa585d040bc09e5323c966544e6d20f268a50bb14856e8f884e34242001a3663"
    sha256 arm64_ventura: "95d10fcf4c982b0c8628b260957bd679765b52af5e4cacfce110a80293c3349d"
    sha256 sonoma:        "b86ae22abfcfd4aba8ea3b3a1c75206c74f84c89083330aba0024d8e519386c5"
    sha256 ventura:       "9ad7a3c0599a5fb7ed9f012c96daea5581d2709ae26b9def48afd3df3d2ee18e"
    sha256 arm64_linux:   "cfa88ed5e01201823b25ba42fc5d33db1fc1c3ab70067aaaac3105b1637b7a20"
    sha256 x86_64_linux:  "31c88b22aea8862c2b6fbcf8e0d54d11c611c5921b8325955f814618124c5f28"
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