class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://ghfast.top/https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_8.tar.gz"
  sha256 "7a42562d4c1b0dfd67783b995b33df6ea0983573b2a3b2b99c368dda647e562c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "09ccb127b83740b49a08de330ed48bc85435d703fa661b5ca0ea3d3f2afff5c5"
    sha256 arm64_sequoia: "01a673a28228d6c80437d5e3140d70a75186efb447aab5529fb9c36e56b1e1e4"
    sha256 arm64_sonoma:  "ac918c458df5499bf5439ba7b4645ea2a4e0a9a2138398c1e8a876979befffb8"
    sha256 sonoma:        "b2c60fdf10b697f223bb68cba09730491f0fd93da292375e48bad19f5ac2b3c3"
    sha256 arm64_linux:   "84af5bacd9978572f465ac51cc4d2f7e8df5e65ecf85bd6aca3bf7462c444424"
    sha256 x86_64_linux:  "bd785cecb322571268dfd34c34de9f77c054a401b8b8f2e6bfba537e1b447123"
  end

  depends_on "collectd"
  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "gdbm"
    depends_on "readline"
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@3"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@3"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    args << "--without-rlm_python" if OS.mac?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    assert_match "77C8009C912CFFCF3832C92FC614B7D1",
                 shell_output("#{bin}/smbencrypt homebrew")

    assert_match "Configuration appears to be OK",
                 shell_output("#{bin}/radiusd -CX")
  end
end