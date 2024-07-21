class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https:www.freetds.org"
  url "https:www.freetds.orgfilesstablefreetds-1.4.20.tar.bz2", using: :homebrew_curl
  sha256 "f920b102124026c23d2aef34275ccfc5864e130290edb6d888f77339dcee7fcb"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www.freetds.orgfilesstable"
    regex(href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "6a7ff4cdfd4048391e5afeffa01af538e470aa67c03f1b6b185cd53b781e0c54"
    sha256 arm64_ventura:  "5ad6e20ca1c4c61dadcf00758b72a22a98f90d4c4653d5f4e110164cb2f61526"
    sha256 arm64_monterey: "849e62c02d98046ddefd1075b692c309a373c18446d7526091edf4d25d64b694"
    sha256 sonoma:         "788876baebdd0c12b1a7a8aa2984156817630b29b273874bdeec59609c3fe771"
    sha256 ventura:        "db7c179e2a68b063158131f2a8ebb871e9d092131093b0d20847c34d2ca089d2"
    sha256 monterey:       "82b37af6d4b98c841260145d87a6aba8c1ba29a95707096b03b5d1b144879eaa"
    sha256 x86_64_linux:   "c64c52dcd081e67f1d5a5d0d78bd74b612f5a6c4feffff04f57ec4976c4fe499"
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