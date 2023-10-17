class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://ghproxy.com/https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_3.tar.gz"
    sha256 "65cdb744471895ea1da49069454a9a73cc0851fba97251f96b40673d3d54bd8f"

    # Fix -flat_namespace being used
    patch do
      url "https://github.com/FreeRADIUS/freeradius-server/commit/6c1cdb0e75ce36f6fadb8ade1a69ba5e16283689.patch?full_index=1"
      sha256 "7e7d055d72736880ca8e1be70b81271dd02f2467156404280a117cb5dc8dccdc"
    end
  end

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ee2072014a86422fbe3bbc18a45f2c4616dd9cf4847dc455f23abe3b4abec5f4"
    sha256 arm64_ventura:  "e42fea37cfe6021abf2289760885aaa7af3bc435f237457362b48cbcfb155e7c"
    sha256 arm64_monterey: "d82420f76875ebbb7c9991909ca268ce1cc5ff365d5adb74406c0a89099d4c2e"
    sha256 sonoma:         "653d3600d83f98a0f61e3dd0a08d581b15ce54ae4267f84177205946165a4d21"
    sha256 ventura:        "3d01018d7a599e3866f3d53c445d8b2ecfa278226512d24a8e2ef313d3a7b2a2"
    sha256 monterey:       "6c0cb688286df320107d38173304b6b575fa1282b87996944a14405258e6697b"
    sha256 x86_64_linux:   "491803883b68aa0040c4def4d5b52b948360f6392fd6e4abf3603d61cf47c8c8"
  end

  depends_on "collectd"
  depends_on "openssl@3"
  depends_on "python@3.11"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
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
    output = shell_output("#{bin}/smbencrypt homebrew")
    assert_match "77C8009C912CFFCF3832C92FC614B7D1", output
  end
end