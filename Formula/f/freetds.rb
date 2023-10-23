class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.5.tar.bz2", using: :homebrew_curl
  sha256 "16c411772bea227b4dd99aa513ff87fc09ee23a2ff8ec7851e5b3ad73227bc2f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b01bf647bf401b01cfbc9da3e4f7367590284d9af16e66e6e1bf8b8618a2e286"
    sha256 arm64_ventura:  "2ec2e24f1423bf281f25acf3ee2ea895fc74964f433dd529a2ec37b559a30fbf"
    sha256 arm64_monterey: "1498ca293d4088b67da6f9aa7beae9d43d739f3d31fc85d2a0cb450a68e82d73"
    sha256 sonoma:         "fd74ba6aa25ac693d5a24bedff4a5cac4ac8deb7810ae84c63a025736de6df61"
    sha256 ventura:        "c58c53d4fc5bb5ce305755a060b8a7d68dc2cae02cfa610fad8ee317114cc44a"
    sha256 monterey:       "6ea228e5906207d24d0fed4d8921a11947546976330c079cb318eb207756c3ab"
    sha256 x86_64_linux:   "ff6d9052bfd48442db8e9cbb9aa4753180c06fbc5266724688d1cbdf3ef9a206"
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