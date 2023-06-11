class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://ghproxy.com/https://github.com/nghttp2/nghttp2/releases/download/v1.54.0/nghttp2-1.54.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.54.0.tar.gz"
  sha256 "890cb0761d2fac570f0aa7bce085cd7d3c77bcfd56510456b6ea0278cde812f0"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "aafcfbd2131f0d6c6db4015306122db9b93304ee2563da0f6470647995b9e31d"
    sha256 arm64_monterey: "50e9ae860fab877716039201276bff9df2270ee813732861a060eaa628f8affc"
    sha256 arm64_big_sur:  "2de8035dd8b004c81f6ede728c474060ec25a0494f9958810e9a0f62f17821b1"
    sha256 ventura:        "c6d8ffd0fcbee23825b132db4d1a49f3b09b15b16578b239de9107f4ce7078d5"
    sha256 monterey:       "c11d1d6c3ce3cb593e80f038e2372c9e02032163aeae5ac171ba75241297c1f3"
    sha256 big_sur:        "a716f768f76d740319d65cc70833be36dcad72005e849c0dd145c6f657891cbd"
    sha256 x86_64_linux:   "4f3977206572dfcbc0fb037776b9cc6a0dcb0d924344890d5333dbf3302cb93e"
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
  depends_on "openssl@1.1"

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