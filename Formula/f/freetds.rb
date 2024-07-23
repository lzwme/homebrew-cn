class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https:www.freetds.org"
  url "https:www.freetds.orgfilesstablefreetds-1.4.21.tar.bz2", using: :homebrew_curl
  sha256 "2ee151920321a419fa728726980ea28f8a7c2ef6f256525c581df3904e06e343"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www.freetds.orgfilesstable"
    regex(href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "2fa29dc83af62a2a796c151f761b54512523cb758c054cb6b7cdcd794fbc4c59"
    sha256 arm64_ventura:  "2f99f855a2ab2742c71f90fc9447f71df767c6d5d9ffa6d34ad93ccd13ec90b7"
    sha256 arm64_monterey: "b5113cdf799c1962d33e4bd43e9b21281be5a7073befef7168d212afee46fc67"
    sha256 sonoma:         "27d92f209caa7c24ee399057b8cc2c7d0d5f52f63a3e9a2187d94507f17aa8f2"
    sha256 ventura:        "1fddfb0dd34796ea26292cc585afa1f2c42b70166c6e615672cf9feed361ccb2"
    sha256 monterey:       "cf395b3939f81165a2ddf517d82ee4bd0c01add91254b264e44ac734b6d23998"
    sha256 x86_64_linux:   "54502f4876a3a2db349eb9ea7187523aaeceba52d9c6ae3a34d427da06c9b12a"
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