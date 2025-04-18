class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https:www.freetds.org"
  url "https:www.freetds.orgfilesstablefreetds-1.5.tar.bz2"
  sha256 "adbbdf527f007257b71e914751d833378a795f8d851f8405e2e3196793215d03"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www.freetds.orgfilesstable"
    regex(href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "d588226f043ce57096e73be82a4b789eeab644974a95597c56424869a437a457"
    sha256 arm64_sonoma:  "ac5c07ee7b1068f3f12804f2b727eff3d3839ed15bb6cc0f41ac01d47c00a807"
    sha256 arm64_ventura: "7bb78557cef4e63783c4d7fb169ce6d9c26785363022c29948070746910c1ad1"
    sha256 sonoma:        "75bd533244e04a7978cf209a0fc150a5ceed0c3349d3b8ec87074484026e0bdd"
    sha256 ventura:       "4009848d2fbe1ec03f4fa7186abc1e0bc80667329ca0799e46cfd7c73aeba54d"
    sha256 arm64_linux:   "05e017724e52e38c2bdee40dbd9d173f2b6f5ff5b9b6be62cdfde3cc8790300b"
    sha256 x86_64_linux:  "1b0b5bde07f93d26741ea734024296460893c7acfd6e757c3c91c3d6a34664cc"
  end

  head do
    url "https:github.comFreeTDSfreetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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

    configure = build.head? ? ".autogen.sh" : ".configure"
    system configure, *args
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system bin"tsql", "-C"
  end
end