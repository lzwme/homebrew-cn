class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https:www.freetds.org"
  url "https:www.freetds.orgfilesstablefreetds-1.4.15.tar.bz2", using: :homebrew_curl
  sha256 "df61a14e155a2e322409f1c068f5ad663649f029a4ecb33a2841f1552608ac48"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www.freetds.orgfilesstable"
    regex(href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "9583ed907f9b75c898e4d00c8e85e9960793dd10b6b1781e62a62d975d52018e"
    sha256 arm64_ventura:  "fb6646dfde3a8207eefc20d8d25c1397fab452f6e4b8e2f2815ff6741bb832fa"
    sha256 arm64_monterey: "ec2f7834967163859ac17d2714d4c6118761a9d6c67e95013d84471d9b83f4c6"
    sha256 sonoma:         "32b1375402720178a645e8af533f35ff68a332825cb9f26932ae42a2b5224ac8"
    sha256 ventura:        "bf96d55babc5314d836db9f1a484399715e730fb14071d4fcd642739988e3518"
    sha256 monterey:       "a5f33af1575a5f23bddadf19762c24a9a43a8a22f454fa12cb1b0bfe7acc12c8"
    sha256 x86_64_linux:   "c868c0f4309a903f982cc3b5f05c20f6c8b12ade84a490fbc60bdf5f09719032"
  end

  head do
    url "https:github.comFreeTDSfreetds.git", branch: "master"

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
      system ".autogen.sh", *args
    else
      system ".configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}tsql", "-C"
  end
end