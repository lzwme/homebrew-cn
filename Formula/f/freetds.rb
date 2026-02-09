class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.11.tar.bz2"
  sha256 "8966e4dc0c35bfd77601ccc5795669a9c868828ba3cb4fbd28b355b461a78aee"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a81ab53b84e54ad99df41ba604566f46e2e1ecd5ea897b13c2ebfc2b6085207c"
    sha256 arm64_sequoia: "a8b542b2c84b7bc3f9bf30e457bfdd24d9fea7e81b16491d181b20b2fa4961f5"
    sha256 arm64_sonoma:  "5cbfdd526ff9f354cacb21ce856357b37f997d0a8c449eab020fde909408f3a7"
    sha256 sonoma:        "f3301ada3792c7568bfd7f6cf3212261d7f4b3f12c2c34dc9c0aedda88174566"
    sha256 arm64_linux:   "e02f5f743ffb48b30ab5afa55e40cfaf1c22e51891e7cfbb078f3e75cba2d9ec"
    sha256 x86_64_linux:  "6bfdfa88f87c54bfdc8305c57404caa36375f519910f5da06d218d595447dff7"
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