class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https:www.freetds.org"
  url "https:www.freetds.orgfilesstablefreetds-1.4.16.tar.bz2", using: :homebrew_curl
  sha256 "d928abc66c4b4eb71173b45a9239c9dd10db652e79133810d5cf6c4116c918ef"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www.freetds.orgfilesstable"
    regex(href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "45d0442293cae37b48fb5e2dbde3b4449d72cd80d3676d9f9c6ecb0b63e95bdd"
    sha256 arm64_ventura:  "599a201e776b55523edfc00172a3b08128a4487d00898babee8156b6e94cbfd2"
    sha256 arm64_monterey: "86d4bf1c6b4a0ab04646147bec8deacd8774e968e0cad2b5c63b252975eba380"
    sha256 sonoma:         "3216f09079dc95fd396d70affc0ba186aaa2dfc338b9ecea740a4ff55d7e9988"
    sha256 ventura:        "4c29a3ff28911ee7cadb011df28dfa8055622449e7797201e4e812ae42a83ff9"
    sha256 monterey:       "7f934dc0c8185117311af07e2941beaf66ddc88f73204a37ccb215b1c234f40f"
    sha256 x86_64_linux:   "01946526f81b867e85810593da26e897bb75b95142e4600da15e57ebe743c6bc"
  end

  head do
    url "https:github.comFreeTDSfreetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "unixodbc"

  uses_from_macos "krb5"

  on_linux do
    depends_on "readline"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    if build.head?
      system ".autogen.sh", *args
    else
      system ".configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}tsql", "-C"
  end
end