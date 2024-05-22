class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https:www.zabbix.com"
  url "https:cdn.zabbix.comzabbixsourcesstable6.4zabbix-6.4.15.tar.gz"
  sha256 "0ad98d0aecc355c8628e29d6728a779465135464b625b89009b9aeb325c142f6"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https:github.comzabbixzabbix.git", branch: "master"

  livecheck do
    url "https:www.zabbix.comdownload_sources"
    regex(href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "371e6161e9cadc9906cbd98e3cd816b5b0e4c81c67e0be697f2e9f6b7cd05e05"
    sha256 arm64_ventura:  "627dcd6d843d6840320766de9d3688bb003f22e3e479b9da05cb57ac230d7f1b"
    sha256 arm64_monterey: "e163655572726b73e5f1f7060039194ef31f23a1d4c60552b079e1f204b4866a"
    sha256 sonoma:         "dd5eaf89586070bfc0d2b0050b884ba0badd3407423a2db63d26e50754b384bb"
    sha256 ventura:        "4f48ac6f6a96355f03bf0c7822092d8512a28131379d9b1708a8e638f1aafc0f"
    sha256 monterey:       "2b7012fdebc8886cf36fbf414e10495b09ca7b43444b5394edf7e4a2f8c84bc9"
    sha256 x86_64_linux:   "c6ec49b0ed8a8f7755eb45d5154f976e557a1d01274c1f8030b20a207ff39b9b"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}zabbix
      --enable-agent
      --with-libpcre2
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}usr"
    end

    system ".configure", *args
    system "make", "install"
  end

  test do
    system sbin"zabbix_agentd", "--print"
  end
end