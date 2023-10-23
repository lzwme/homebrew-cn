class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://ghproxy.com/https://github.com/acaudwell/Gource/releases/download/gource-0.54/gource-0.54.tar.gz"
  sha256 "1dcbcedf65d2cf4d69fe0b633e54c202926c08b829bcad0b73eaf9e29cd6fae5"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_sonoma:   "4c4e8cbc4ec6ec1be0f7cca3e71fcd357e6b13e2f4ce2c701d5acb4e01e7ef69"
    sha256 arm64_ventura:  "e765237f0f2874f0bcd9f5a6417dc564481cc7a44ae3876b757db9ed6b071aee"
    sha256 arm64_monterey: "a0a40ea6d27b50f6ad9e7eb3174d3cbb8e321714d51e8d3ecb32bc85bd86e334"
    sha256 sonoma:         "f5a066d6662537c0b73d11dbdca02c55805cceaa07c9b1d21175da06a6ed6385"
    sha256 ventura:        "b93f2564ca0aec57255d50919b84af39b7f1f898528c2bde137502f87957685f"
    sha256 monterey:       "a643b32220e047cfad841a9d5a8a1c2b0b0d6e84d7fb98d997f85eac17cb6559"
    sha256 x86_64_linux:   "57c547803a9d396d1b5bc3e304d1ba8725eaecfcb5900bbf0a90ed6ffd74bb48"
  end

  head do
    url "https://github.com/acaudwell/Gource.git", branch: "master"

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
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    system "#{bin}/gource", "--help"
  end
end