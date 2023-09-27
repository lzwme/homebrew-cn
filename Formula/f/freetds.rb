class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.4.tar.bz2", using: :homebrew_curl
    sha256 "35cb55743c5c2e0b579caf180eebb5cb4a65155b7c7aa3428c1b6b5d3cc291f4"

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
    rebuild 1
    sha256 arm64_sonoma:   "678f903de89b18bcb772dcb11a831fce4ed888453c38c366fb998b4fd87e1407"
    sha256 arm64_ventura:  "73a6ecfd16ce5dc98992cdd85668363a4dbe83730cb5fb03ae12d276387d8985"
    sha256 arm64_monterey: "7f10873e41bba6b15e0e60fb8341801eecfdca01dad974fbc5d5a01b8985d96f"
    sha256 sonoma:         "bf11d3da7d30bfb79977d053fbfd098e97f4bd28eb7113168886333fea75227e"
    sha256 ventura:        "8481f3e35bf0162e472d06712c77d8ccd1a8ace6d18e51b2d5ef391f15c859ac"
    sha256 monterey:       "37169f967145ec7c9192a9a5c952eaefc9e2af7a072a7fa95e5046b2faf00379"
    sha256 x86_64_linux:   "f05d44c14c92f001650cfaaa4b0eee26e176af33cd47d495e00ffd87ec3b38fc"
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