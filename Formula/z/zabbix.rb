class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable7.2zabbix-7.2.1.tar.gz"
  sha256 "41c596f6b935dfa371f8d86d3c11867eaf61a3b635474baed7029c9f1d053570"
  license "AGPL-3.0-only"
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "559cdfca8486b90e599aa36ca6779ac5b0b47f402d525eb1c383b52813698322"
    sha256 arm64_sonoma:  "86449000d3263400aa7324d5faf701cf07efb51963cc085795399bc47ecf3b15"
    sha256 arm64_ventura: "f20842ee415396a3036ebddbfae7b41fca30e229c0a751b974935def9117c29d"
    sha256 sonoma:        "967f97a3f0a1d659e01744bc73ff079a1c798708fc81219f50c618706b648b9b"
    sha256 ventura:       "8f1105b3cd41e68bdd0c85166875b0c370246fe391bf13f35513281d406b70bd"
    sha256 x86_64_linux:  "bcc9abefcb758ba207f6da96748f331e07e6bac13b72a6daa991f2b429bfc3ad"
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