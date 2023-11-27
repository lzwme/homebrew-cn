class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.8.tar.bz2", using: :homebrew_curl
  sha256 "2b35da2f1c66c54ac4f6e403db3a4ab983a12e98b86bbc4c82267169ff93ab69"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e7c538579903d24d9c9bc01cf1dd1c79f52e7aabe6dc614acd277ba56211e432"
    sha256 arm64_ventura:  "b8d1d1ff8f09709fb28c499c8be4ca660354eb0c12134e97268b5400a933af3e"
    sha256 arm64_monterey: "3700cd7f074e772803d5127986c16b6c07da8dd3bc69a5cb71464332359bb42b"
    sha256 sonoma:         "1394914b47e38e0f2949709d625fec760276289621a86207f26dc1a9280c57c5"
    sha256 ventura:        "971a6dbf1ffb116154c9fc278991d6c49024a5782f7a373879f3ec8c90a5457a"
    sha256 monterey:       "aeaab465e6c7240b19da39db9280374d49e8e7a52aadb1c4f2be2c3165da57a3"
    sha256 x86_64_linux:   "7460608a792c8f5046b4487f78aa74deb839e4ad982cc42924f8542f9265e399"
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