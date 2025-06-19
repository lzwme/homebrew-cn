class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable7.2zabbix-7.2.8.tar.gz"
  sha256 "2d0cb04f628b8501c99c1ccde70b95cc63fd9ff9c967370dbb27d542a805239c"
  license "AGPL-3.0-only"
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "873a97f1d21ebe8ac14ef68871e23c281cdd54a5bf5765bc3e1f1bf594628961"
    sha256 arm64_sonoma:  "f898114777835f3a90a44248d2e5d46bcc6b62ecffae4c30175d2302f0c0686a"
    sha256 arm64_ventura: "c5e9c8cac1c925c4811886555643883b0b32f6b9808bddfa0a996362dd4c9fd5"
    sha256 sonoma:        "69d925ce77aa31fb47ecdfcae58f3a160286f7f0ec00be8f52b8890a2b244f1e"
    sha256 ventura:       "d30a2061b9c99f652774d769464013b308e4367f1f3a44ba6bed2311cd0f2660"
    sha256 arm64_linux:   "082d2b88f93de6b42fe598cbdcf2d0028d4d983495f5e300912273f01fa231c0"
    sha256 x86_64_linux:  "539bef184a64ae440a09b531b061fe2cdf5ea158338518ca84227baba6b5e3b3"
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