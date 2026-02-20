class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.13.tar.bz2"
  sha256 "0c34f60027d714fe11763da14c299d253bbd8c6b8e542a4cdb46f4545f70045d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0102ad9c5578f8da74a91b47cd7b9987279c1e4393bf3735337518949588cd47"
    sha256 arm64_sequoia: "e4e6dd2137e4fb856406bca63312937818f74bbc7620d6a3ead0710fcc4ac35e"
    sha256 arm64_sonoma:  "6eaa110740453a6ef90c10cf6f6c3367ff6bf39d3f62998aa606a70a3b811e9b"
    sha256 sonoma:        "a3cfa18a40c95ca250aed3a3930390bcff7ef7a697269df1383215bbca312b4d"
    sha256 arm64_linux:   "aa72ec7c4b377008ed6496426c01a090675f563c408fb7481529682947d9a86f"
    sha256 x86_64_linux:  "1ac5b3d470a44757b85bfe9cbd57d788c9ef856072f3e3e5ac905c2183b321f8"
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