class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.4.tar.gz"
  sha256 "bdaaf7cc256b2bd0f78800647012b08d0b385f8cfffaba67d852a8abe5d5f0d7"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "80815e9f41130a88fde93fd91898c3c7a6e8c4a497d747004ca1c4af97baae25"
    sha256 arm64_sequoia: "2c1a17c315a1f3cd8d19ba811c938de1aeb46dc77a9afc13fe938bf7358326b3"
    sha256 arm64_sonoma:  "dd18f2acf32d95c8f123e409e8973a2f64e2411c38cb59c2e635673a78e12609"
    sha256 sonoma:        "aeca1290837176eb3decf7062db8c6dd56abf06778a304be359770bdc16b164e"
    sha256 arm64_linux:   "22eaeaf673a69dc2dd679ed17638a4da72b83b7e565bdc1b9fed09c9442e8885"
    sha256 x86_64_linux:  "ff5418cd27cd8c295e5f8cf023dc9cc40d620e0579aadb1db1ef84c52f9b3fd1"
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
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end