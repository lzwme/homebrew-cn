class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https:www.freetds.org"
  url "https:www.freetds.orgfilesstablefreetds-1.4.14.tar.bz2", using: :homebrew_curl
  sha256 "670d5449e6d7903cc18751623adba6cd23a4b8ae01c1dc6df2bdb0bbedf0da3c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www.freetds.orgfilesstable"
    regex(href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "f9895d425bb5bab942913593a08ad15735667a7bcf6fb5af2471d83d40d59bee"
    sha256 arm64_ventura:  "ecd66725e154519b296afc796f89de2aafedf89d21aa1da50bcdd2b836b039cf"
    sha256 arm64_monterey: "dae9348909aa04c05850fa810c0317ff8cad9c89d4599b6b5f77bcd64434d10b"
    sha256 sonoma:         "25e0fee2d8ad6486e3fc27a0d71027c4edc8b0fe6419a8336a9bc955073344e6"
    sha256 ventura:        "090cba6c940ad41d4ee8117a5887913fc9307e64f1b9f937d38d14904d053eb6"
    sha256 monterey:       "3029c6b985b1ce28dfc7c8eefc4c5237698543f26c99fb738015963a81d31008"
    sha256 x86_64_linux:   "c8f754d1784f571b64eb52e777935b241cb59fd0b267b4fd21a9fca315f42209"
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