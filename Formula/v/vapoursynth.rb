class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://ghproxy.com/https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R65.tar.gz"
  sha256 "2bde5233b82d914b5e985119ed9cc344e3c27c3c068b5c4ab909176cd1751dce"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a636bc5f91e84332d9d60d234162eec54da964bac8162a93239857bac061368"
    sha256 cellar: :any,                 arm64_ventura:  "422cf52e71ffeab11d3ebec122e61a194971f1782e5b5c0101efed8e440c6533"
    sha256 cellar: :any,                 arm64_monterey: "f39f1d71e68a0ea7569ad8665055f469ec8ce8ca0aaa352cdced0724ee8e1cd9"
    sha256 cellar: :any,                 sonoma:         "f2f73729d783c8f2aeefd62df61852b1a941d7a6ab15ad9e431c8de8e67fc767"
    sha256 cellar: :any,                 ventura:        "c3c3656d48fbf391ea68ade97066ac4c3ac087e22d5c44dbdb918fbb3e162782"
    sha256 cellar: :any,                 monterey:       "cb9079c7e5149cc1ab934abd4a4fbc1c0fcfbcbd32f7460f6de8ee72b9a0ff8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b340220ba5f6667b3f24e2fdc6c26f44403f81c3a6ce9d3cc217ebd97f7295d1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"
  depends_on "zimg"

  fails_with gcc: "5"

  def install
    system "./autogen.sh"
    inreplace "Makefile.in", "pkglibdir = $(libdir)", "pkglibdir = $(exec_prefix)"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--with-cython=#{Formula["cython"].bin}/cython",
                          "--with-plugindir=#{HOMEBREW_PREFIX}/lib/vapoursynth",
                          "--with-python_prefix=#{prefix}",
                          "--with-python_exec_prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      This formula does not contain optional filters that require extra dependencies.
      To use vapoursynth.core.sub, execute:
        brew install vapoursynth-sub
      To use vapoursynth.core.ocr, execute:
        brew install vapoursynth-ocr
      To use vapoursynth.core.imwri, execute:
        brew install vapoursynth-imwri
      To use vapoursynth.core.ffms2, execute the following:
        brew install ffms2
        ln -s "../libffms2.dylib" "#{HOMEBREW_PREFIX}/lib/vapoursynth/#{shared_library("libffms2")}"
      For more information regarding plugins, please visit:
        http://www.vapoursynth.com/doc/plugins.html
    EOS
  end

  test do
    system Formula["python@3.11"].opt_bin/"python3.11", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end