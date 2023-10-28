class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.6.tar.bz2", using: :homebrew_curl
  sha256 "813802a1c6bc02fe1696b6ea31aa535225719777736b5bfc23a3a17858956ac0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "62ab66647511ca65f7ca1cc002af4591b2d0d80c33986f367b2ba5774e5171fa"
    sha256 arm64_ventura:  "3465c2e878591b8d8e479666e51bcfc4cd639f680d2e5bc9d81184ecaebd7382"
    sha256 arm64_monterey: "a5ed26039fafb7a41088037ad8d9dc66ab7972058e053628dd2360db560034cc"
    sha256 sonoma:         "74369228f07a461fac25630ca727f738f093fe31d1e8c7c758d7f5e73c4cd174"
    sha256 ventura:        "47d6a7afd3c499f059f3aba9e502523394b5f90398a00db2e2b74325d7fa29b4"
    sha256 monterey:       "5fa969a9531a391d86b66f65275effbbd39965a88e447a946af2e0fe45275a72"
    sha256 x86_64_linux:   "4aeb0cfacffcfebabcf5bdfd28b259f1c04cf3e0c1d5cd9539e3e989b0c5ead8"
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