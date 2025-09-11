class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.5.tar.bz2"
  sha256 "763d096ee4a2100f8d36e1447bfe2eea5db50875ae30af587f8a1312c3bd6011"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7ab293e51aff94c54053cbff00eb402cf00b26ddfc37bb77847e4dc78c3ee3f3"
    sha256 arm64_sequoia: "d20e4d1ef309d6069a3b8229b8bfd717486c9ac58e08020c042db755608fe03c"
    sha256 arm64_sonoma:  "3ee3b10c8da8a49c9faf83cb113ff5949275629cf8fe9e37bb38fa6a828efef7"
    sha256 arm64_ventura: "96134d3edc47e1e8589ce4c84dec5bae0059fe1cbf5cb94f4e3d7ead8c543f8b"
    sha256 sonoma:        "f6257551477c0590fa2a9e303b3a71ddbcd21ab9267ad10ee0cf868d0a76d213"
    sha256 ventura:       "fda8856890bf0d89d4dcf4016be68f24133cd41033dce080a22603ba1db93da8"
    sha256 arm64_linux:   "d58f5cf65166b7cbe2fc171aea9cf3d8497ea6098c152466a967fa0b19bfaec3"
    sha256 x86_64_linux:  "bff8e8c6ecbd1643aa030a41e984e187abf5f8b7172c9dd493f45a1806bd19c8"
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