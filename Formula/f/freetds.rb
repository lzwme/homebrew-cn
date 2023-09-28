class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.4.2.tar.bz2", using: :homebrew_curl
    sha256 "8acd1339989c64709803e227d2082b7ad264be66aebd4dba2c69a768acb86713"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c9120bd2e0eeb8ac83070e2b4dd85bac6d4ede21060b97b4617ef2fa1cef3ad8"
    sha256 arm64_ventura:  "c4ee0537863f8d5cb891610541a66f38dd85dee478bb3282ce2ad67079ee10f0"
    sha256 arm64_monterey: "21f428399d59d6ac8a63e34b6aa50e3866085ad60f84930d1d129a872ea8ba59"
    sha256 sonoma:         "7c300eab4b6a19e18780e8df18fdc20f88aff63d7faf5178093d757eee9a8bf3"
    sha256 ventura:        "1b22d5bb693f17394314e54c38277182d25322a16d2f93e4a3a4dfc979e6b86c"
    sha256 monterey:       "4484def0b0373f0416f2d50dc22e5c80a83e1602f9028f90d0d25553edcf0906"
    sha256 x86_64_linux:   "64910efa73986bbb9038e762f498be159026cd75f7c435e293111a7d9f305d5b"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

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
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end