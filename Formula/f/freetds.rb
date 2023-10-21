class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.4.tar.bz2", using: :homebrew_curl
  sha256 "f1fb755d3f979e90e90e6733d46311c839791a3d6e47709ac858a93f6a47a736"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "845f9f692e1803bace12859fe18f949f5f8f6e9290ce13b5ad15a4dc619decb4"
    sha256 arm64_ventura:  "b045d43ff5061f1ba6e464bf0eb59ce58ade2e6f8e14173c59e7450a37cb993c"
    sha256 arm64_monterey: "5cefcffa8f78d5165e145c6b55f6deed169edef6376e38394258dc96ae80ae85"
    sha256 sonoma:         "3e310a7093a73f691cb8ee2486e4127acfcfe050abda642bdf6961f2c0fccaef"
    sha256 ventura:        "50280b9038a823587eb17e51b1b2d28503256c4d8772ee8964e10f55aeafd433"
    sha256 monterey:       "222802fa936cf04ca147ded98df3c2366b113e94aa35631849872afcc38e6bf6"
    sha256 x86_64_linux:   "b54a1369035b7eef68009f71e345355af9326528a9f0a18e97b160274cb7616f"
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