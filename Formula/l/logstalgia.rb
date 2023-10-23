class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://ghproxy.com/https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.4/logstalgia-1.1.4.tar.gz"
  sha256 "c049eff405e924035222edb26bcc6c7b5f00a08926abdb7b467e2449242790a9"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_sonoma:   "685093bb7cfa7330db24916b3903e33410f6a21bdd4d013c3690651ecd6ae76d"
    sha256 arm64_ventura:  "caf7e0b86a504e7c83db80af1460202d06e2d51146f71ef93fb116deb6ed745d"
    sha256 arm64_monterey: "b14207d569dcc191e1a50c74645a23b16037a1e423fc5e8cd335c40f19354455"
    sha256 sonoma:         "0ffbdf780fdde24f65881f57cc93a78eef7301972ae45efb8bc45ddac2c953c7"
    sha256 ventura:        "3df6ae73c4450329a7b30c51cc22d37fe8831bc1708775f17b98b0ade58d08ba"
    sha256 monterey:       "f5198d4af8920f57fb3fa14e02fe6d67a006572e54faf765ce82f917ede85dc9"
    sha256 x86_64_linux:   "41b545209f540fd88670cf2054a9347e0989daed01a991e708734fe7bd7b20cc"
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", *std_configure_args,
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end