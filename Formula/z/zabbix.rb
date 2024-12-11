class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable7.2zabbix-7.2.0.tar.gz"
  sha256 "65fe4bdb366fe87acc9da119ad11204b0867363d2b76ebfa3b3bc5702dd29fed"
  license "AGPL-3.0-only"
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "d1ffbf3553d21f969033fabfde8c5183ff37b0f8fd002771444d6e9890e102ba"
    sha256 arm64_sonoma:  "6970b9540762bad45e024089e909bd1955be2dc79670eb826ff8e215d45f1b5c"
    sha256 arm64_ventura: "f154b2019f01e72fba302d36213bf30b029161fe28965310dec8758ec5f1d3d5"
    sha256 sonoma:        "659f06a6e97e73f0b55da4f86c9c8b8f6f70251dad1d16274d1838b4f66f7e5f"
    sha256 ventura:       "6457a0ddcfc4737c817e1a601d13fea41a44936164daae437c52931f811c008f"
    sha256 x86_64_linux:  "ebe4d71dbd2a0b7ca87cf30d70d4d648da358729355af01c34789849cbf3758b"
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