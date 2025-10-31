class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.7.tar.bz2"
  sha256 "ed46ad89b69b3e6dea78211b0322c08ad4a99e0d502650fdf1d415090f92ef8f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "dc92f6449343b79acf532ce10577c74f3f26f001af45875011db9995daa26fa2"
    sha256 arm64_sequoia: "d5169d4051c3567504e1e7e90b909a5ad0ceec7b21177e96e10a96e145431304"
    sha256 arm64_sonoma:  "cbafe4c0f11eff699fc02b8d4253898d7aa2b6ce68aa1156bad6a408d9654c7c"
    sha256 sonoma:        "cf63d153f56865590f7c01b3efcbbc184427cf11bf9acf6fd69ddb40b8d459ab"
    sha256 arm64_linux:   "6fae0a9f1f3819dcacfffeee3c316086d4f1730afb4cea67fa06fd45130679db"
    sha256 x86_64_linux:  "2a50691d8a84e497e63a2cde8f817166a8f3062c540c755432524a396d528983"
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