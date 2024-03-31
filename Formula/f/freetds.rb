class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https:www.freetds.org"
  url "https:www.freetds.orgfilesstablefreetds-1.4.11.tar.bz2", using: :homebrew_curl
  sha256 "567f7ce913f222191dda7e1c221d5e272a387152fef6cacbd97767fea68b613e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www.freetds.orgfilesstable"
    regex(href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "638ce1a7b3440ec754565e8dba96842d53f0c041ca9a97a90eb1dc338cc9e73b"
    sha256 arm64_ventura:  "06c7e1bf6cd9a3daaa5134c33b0df9f63d637ec4dc4276a20f670383e05e3e6a"
    sha256 arm64_monterey: "4de89308b3b5f9788dacfc47720dc100bea92991b2ff65309e853db13c7b3254"
    sha256 sonoma:         "bd2a0f812f43d7f1906b4699d1a25f075cf40977b54018e65f0b9d6e23328d21"
    sha256 ventura:        "622d2e90daf8abd6f5b734295ecc75457c0f734acb2292e6fb9723c941e2afce"
    sha256 monterey:       "05c6e34082eba3d2010b6e71dd9821c96f33fa230df685197a27dbf6a5ef530a"
    sha256 x86_64_linux:   "5a9dd78ccaf289b028781bd3e897843fca7cdfa7db0f6492c17d80a9b214f8dd"
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