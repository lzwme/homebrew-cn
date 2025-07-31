class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.1.tar.gz"
  sha256 "02d4edb41b9747c089f7ca45bcc8dccdd1779f88b493dc15ff9f70dba9f53943"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a45ad9595048a4441843b937efbe3debe7c7a9105ca6218d77a9ddc4037bfb84"
    sha256 arm64_sonoma:  "d46ca2275fcdcba38b142a41b5df2acd18d5ce55ca112e1f4d8d0708eda56abc"
    sha256 arm64_ventura: "facbe84c062dd710ca67462a437d012995547f76fdc43e36abdf368cb38363dd"
    sha256 sonoma:        "0c877eefde4920eeed4163ed004644e433b84a7f74aa46b80a3c8d456b33194c"
    sha256 ventura:       "fc59d0a1837a8f9462a08282ecfc9c6df28c379dbfbcdc365b8e6960c29546c5"
    sha256 arm64_linux:   "2a7e2a4465dcaff704bf542a05a5ff51cc84cab79776d3e59cd051e75f48db44"
    sha256 x86_64_linux:  "1d992bc0978351da63dfb17a9495533d9f28115926b76b528f433887c436b00f"
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