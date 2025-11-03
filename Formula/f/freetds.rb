class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.8.tar.bz2"
  sha256 "4e7a8afe83e954197084e3d2127be1e37ee9dd5deb0d9e705467e60ec73de4df"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1d9ae5e99830018dc55a13ce633db247eec1d8d6a8c56458b9b343c3ad239900"
    sha256 arm64_sequoia: "ea5051e7702a4a0801e0dab1d1dd4c140be41d5b897ee2776a3e0c0f26608575"
    sha256 arm64_sonoma:  "16bec4fe3f7bc47e1f4dd7d36982fc2986835def30451a6131f1a0015dccbbc8"
    sha256 sonoma:        "2c15f415c435d813424b50ef2e9871909a00f58fa40ddc210d9a2ab05c80ec00"
    sha256 arm64_linux:   "d338e5ea10b54f64aad3f8168c9ee3dfb71ed3f91eecf47e24ad2ac38ca6c8a2"
    sha256 x86_64_linux:  "be872500fff4601d557747b7327688b14c6744f3c391bff2d51ff69c6734d837"
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