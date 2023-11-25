class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.7.tar.bz2", using: :homebrew_curl
  sha256 "c5302e4268ed103dac2f7308cfc7097ee293907cff729b10c740d007f7a1ad95"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "90e9932c80b5eebefd60e119913374a4565f80d9345371bd7d8a5bfa80837434"
    sha256 arm64_ventura:  "2aefd5d58c81c65a7af637892a91e8ef018fe49081f22b73b8609865c1366cb8"
    sha256 arm64_monterey: "59896fb33a13e3a923568c34afcb45db06c654a7e94248dc75cea4d6aef90242"
    sha256 sonoma:         "0fd00e2b3abb3fdde60d74a1d3806b1ff170d150fb27b6fa4704274fb9700c53"
    sha256 ventura:        "6f4b37193617b559ce3fa32b37bafdb6ce6b310d1d6c9dc2b6525f6056926a1a"
    sha256 monterey:       "91676e955d9bacb361cd1105db8e092e69563f6ddb4067edb2630e465533e91d"
    sha256 x86_64_linux:   "ba3e6e36429f02e4b443d42f85671fabb084582da51a6d00c80e382adafb3a1b"
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