class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https:www.freetds.org"
  url "https:www.freetds.orgfilesstablefreetds-1.5.3.tar.bz2"
  sha256 "5cb66c46a60a83b8a2855e466148b6fa27962c7fd1dcb3f6e5d0ab17ec5ff6dd"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www.freetds.orgfilesstable"
    regex(href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "6d432bcbcd95bb679a2ab166c896f4aab6ac577f0b8e677eb545e82a08194b5c"
    sha256 arm64_sonoma:  "e10692ae34aa0ea6ec343f1c672a83db63c62146c76ba4cc662469fdaa216017"
    sha256 arm64_ventura: "20e1716f3d664aa481d5798ef42a9ba317cbab22f3fe2825fc9016cc9c9c380c"
    sha256 sonoma:        "1ac84f3acb605816db10f61b274862a8fcad1652e4abc29111796c6c95153ad1"
    sha256 ventura:       "23bc98b9e70c5d2d835f741b428e32f13720a83a0caa03f949c3db3dfba901ae"
    sha256 arm64_linux:   "b7c199b94a458e3a670615cb4e4d5c544a7ea8ebdef59ed8ca7c69089ec26e7e"
    sha256 x86_64_linux:  "6fe5ffa98bbd2e92511da5f49fc738d915912c397f14135d4e6545e09d651fb4"
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