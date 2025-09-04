class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://ghfast.top/https://github.com/nghttp2/nghttp2/releases/download/v1.67.0/nghttp2-1.67.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.67.0.tar.gz"
  sha256 "f61f8b38c0582466da9daa1adcba608e1529e483de6b5b2fbe8a5001d41db80c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "42f88b4ffd14a43cbfb6a9f03db80ab16366e50d3a91181f51d238418058b0c0"
    sha256 cellar: :any,                 arm64_sonoma:  "ea29e690d42fef25bc3e85809178e9e1c44e4f85dd31a806b1d29ab784a97f91"
    sha256 cellar: :any,                 sonoma:        "85f786edaa108e482b766c7751be3b72110945a5cdeb877e3f4729b9aa71b24b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83b07a9f03933f7bdf35c271ccd71e114abb3f2a70eeda4dbf8d465d762f47bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b719af7e146ed2bac32730c617c8b78fe5564bf0190d67b1cbb2bd889a12f3"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "c-ares"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libnghttp2"
  depends_on macos: :sonoma # Needs C++20 features not available on Ventura
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    # fix for clang not following C++14 behaviour
    # https://github.com/macports/macports-ports/commit/54d83cca9fc0f2ed6d3f873282b6dd3198635891
    inreplace "src/shrpx_client_handler.cc", "return dconn;", "return std::move(dconn);"

    # Don't build nghttp2 library - use the previously built one.
    inreplace "Makefile.in", /(SUBDIRS =) lib/, "\\1"
    inreplace Dir["**/Makefile.in"] do |s|
      # These don't exist in all files, hence audit_result being false.
      s.gsub!(%r{^(LDADD = )\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "\\1-lnghttp2", audit_result: false)
      s.gsub!(%r{\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "", audit_result: false)
    end

    args = %w[
      --disable-silent-rules
      --enable-app
      --disable-examples
      --disable-hpack-tools
      --disable-python-bindings
      --without-systemd
    ]

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
    refute_path_exists lib
  end
end