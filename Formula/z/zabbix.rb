class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.4/zabbix-7.4.15.tar.gz"
  sha256 "5e1d9b3747ebf9b81d5d62d8ce00ef9b3f7f4c081394ad11a2dd18897a24f394"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "6e7234867cae48972269c301d019a3c4bea74a083558bfd4491e60c969ec499b"
    sha256 arm64_tahoe:       "a0cf6a58b0cb475e85fdcc733c77c6e560ba31cd2562a33829957f5ee804ad83"
    sha256 arm64_sequoia:     "8c4cdc78f9e7bfc451b4bb0d6ee8558dec4294ad9895f38f2654bfb836b8ed0c"
    sha256 arm64_linux:       "bc7025d351bd6bdf2cda72c7a2408aba3a22970e8c6701953a0df8d2a2aa5529"
    sha256 x86_64_linux:      "b3e55cdc4337692a1f5d9ca178332d2b8ab484acd5d34aff7a40f7f3beaa7c88"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "pcre2"

  deny_network_access!

  def install
    args = %W[
      --enable-agent
      --enable-ipv6
      --with-libpcre2
      --sysconfdir=#{pkgetc}
      --with-openssl=#{formula_opt_prefix("openssl@4")}
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