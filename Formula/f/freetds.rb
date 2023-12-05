class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.9.tar.bz2", using: :homebrew_curl
  sha256 "f191ff106fe34ad4d277a3f83c7ebedd35b92436549b197a82a2d92025095598"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1fcec005bae9b4c5ec6615ce1e4a6248b72a523f17a8d36563c49eb35d832423"
    sha256 arm64_ventura:  "8953434e15d48facd63f406f605d9cf36f1525e1789850de2ec027a10c17bc7b"
    sha256 arm64_monterey: "dc9cf4710010e741e500b963bca3271dc28b4f8e6d4960c7dce89b83a20d44d4"
    sha256 sonoma:         "768169bd8db27ed0c4a1670094b21239c158b2e102124ad41740ba89016edf78"
    sha256 ventura:        "a8826f092b2e2ac443332a5be0e90f878fb5f4a36d5a36165bea5f14bad90765"
    sha256 monterey:       "83b53e381982e0aeffd6eeab1ba54be9841ccd925b091efb199632efeceb65a8"
    sha256 x86_64_linux:   "12f04553e73a17f330ac0849e647c8040dcb03efd3b2f9a0c8f015a285cb52c0"
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