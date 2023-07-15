class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://ghproxy.com/https://github.com/nghttp2/nghttp2/releases/download/v1.55.0/nghttp2-1.55.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.55.0.tar.gz"
  sha256 "1e2d802c19041bc16c1bcc48d13858beb39f4ea64c0dfe3f04bfac6de970329d"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "7fffdc36c2a5d0fe319a1daa5dd06f5403e11b881fa73ecab2f08484cf2af8b9"
    sha256 arm64_monterey: "5d11908c87eb7383355e0b1e707ee5b40b11b009f74fd7bb4bae0d3e90dfb7ce"
    sha256 arm64_big_sur:  "d2c9ae7b65441e872b07fcb8347e7cef21112302ea92c897425d1549f479f305"
    sha256 ventura:        "45e18943d991206715dcd479d8a161cc7b4a7a4a765fe1a5f0be83ba70009309"
    sha256 monterey:       "f55b2f7ff8d9482ae4b7824e01207cd14cf17f5af3c97e47752b17b8a91093c8"
    sha256 big_sur:        "17a594a199d3fc687dc80efc2d14bda5e614adb5064bab2c735e3768e2446c21"
    sha256 x86_64_linux:   "40763a1a0e71e28b26f22c0bf1123c769b384393ca62aade9a777bd50061bce0"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "c-ares"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libnghttp2"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  # Fix: shrpx_api_downstream_connection.cc:57:3: error:
  # array must be initialized with a brace-enclosed initializer
  # https://github.com/nghttp2/nghttp2/pull/1269
  patch do
    on_linux do
      url "https://github.com/nghttp2/nghttp2/commit/829258e7038fe7eff849677f1ccaeca3e704eb67.patch?full_index=1"
      sha256 "c4bcf5cf73d5305fc479206676027533bb06d4ff2840eb672f6265ba3239031e"
    end
  end

  def install
    # fix for clang not following C++14 behaviour
    # https://github.com/macports/macports-ports/commit/54d83cca9fc0f2ed6d3f873282b6dd3198635891
    inreplace "src/shrpx_client_handler.cc", "return dconn;", "return std::move(dconn);"

    # Don't build nghttp2 library - use the previously built one.
    inreplace "Makefile.in", /(SUBDIRS =) lib/, "\\1"
    inreplace Dir["**/Makefile.in"] do |s|
      # These don't exist in all files, hence audit_result being false.
      s.gsub!(%r{^(LDADD = )\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "\\1-lnghttp2", false)
      s.gsub!(%r{\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "", false)
    end

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-examples
      --disable-hpack-tools
      --disable-python-bindings
      --without-systemd
    ]

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
    refute_path_exists lib
  end
end