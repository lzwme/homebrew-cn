class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.2.tar.gz"
  sha256 "3aa55a70e1cf93766e15fa855332dc54601b5e2aaebd3edd324c7fe413ea9ac9"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "12310f3fc9edab0fbc3c6c164ced447664ea880c247d7c437f94a6c858190e71"
    sha256 arm64_monterey: "0dfee63b2289c005b4c96fa4b4c6312a2b4dbdf47183e36f02c3cd4b29699382"
    sha256 arm64_big_sur:  "6b673e4f80463906e8f78f6735deed2f25a76ae3032751881d5cda996e632c98"
    sha256 ventura:        "2a5c701cbd96ee4b66fc2583d693bbefb52412b3b0cf0d446dccf8b60b70b33a"
    sha256 monterey:       "339d3972e181995d84e098b916854c28ac063ac19bf78815e0271826523a4d0a"
    sha256 big_sur:        "bf20b30379a391713198c06c92f5e65ce2a4e61698c723e503c076da9f33ef86"
    sha256 x86_64_linux:   "05017b8e66e83bdfd1c6f868f6ecbe4b974df7cb2e8a4dec7275a4c6be3f577c"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre2
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end