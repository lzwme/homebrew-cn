class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.15.tar.bz2"
  sha256 "41eaa4e507620402f133459de88f7eb48b6da77138579d888c617faae8c2b027"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "338fc7bdcd3ab450ef55100353761b9ba77709dafd6d0d5046e541d6b4761d77"
    sha256 arm64_sequoia: "59114f8e96b4bf4ecd83512ecc7ae59eec3434dad250d3aa2a1521d8dbd7fe45"
    sha256 arm64_sonoma:  "e55e83c514d81ecf9060e56e5317142495b1133e763d330b7cec4fcd93975578"
    sha256 sonoma:        "84f5d580cc8f5669b2e924d9c116c26692ffaaf7fe1038af3adcdb7324e7f5a4"
    sha256 arm64_linux:   "82c5ef22b448804a11051c84dbb99c806a7d8a66d54d4aa1bf7ad7630600903d"
    sha256 x86_64_linux:  "f7bf91097b4f0bc3a6c5cacc482fe964afd899f9abc811e5a8bc7eaae04689e6"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

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

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system bin/"tsql", "-C"
  end
end