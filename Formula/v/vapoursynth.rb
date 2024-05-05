class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https:www.vapoursynth.com"
  url "https:github.comvapoursynthvapoursyntharchiverefstagsR67.tar.gz"
  sha256 "0224be706a251d7936396aa83dfb21c7a7764c8bd80c29085a6415ac1453420d"
  license "LGPL-2.1-or-later"
  head "https:github.comvapoursynthvapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(^R(\d+(?:\.\d+)*?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "918c12ac7b65e032b21ff3eda5e56beedf6921592a5a9288c097ac1138999cc7"
    sha256 cellar: :any,                 arm64_ventura:  "f93cc15fae89ccdab14213828f8a8f785468608619109d24c0d94d8ea0d3d7e9"
    sha256 cellar: :any,                 arm64_monterey: "d0ac67bf4df649d300b579df2653bbe692ae116c37e3749ba00089e6c04015f7"
    sha256 cellar: :any,                 sonoma:         "1edd7a164c36932cf481a565699b4c0f50de4240118b2e6c0f4e42516f5c46f5"
    sha256 cellar: :any,                 ventura:        "5d07cdcc1a2f74e758e5bd3e60e2117d43291a63a77171d7a5b80a92c5b2c9d9"
    sha256 cellar: :any,                 monterey:       "2bffa182f4ec2921af0943f177ea21542d7a9ab24e9b52f9becf3e6a80e7a085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "931129d02c278a89dc0c9026539148abd7a078846e0d27b716f6bc581a5ff3da"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"
  depends_on "zimg"

  fails_with gcc: "5"

  def install
    system ".autogen.sh"
    inreplace "Makefile.in", "pkglibdir = $(libdir)", "pkglibdir = $(exec_prefix)"
    system ".configure", "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--with-cython=#{Formula["cython"].bin}cython",
                          "--with-plugindir=#{HOMEBREW_PREFIX}libvapoursynth",
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
        ln -s "..libffms2.dylib" "#{HOMEBREW_PREFIX}libvapoursynth#{shared_library("libffms2")}"
      For more information regarding plugins, please visit:
        http:www.vapoursynth.comdocplugins.html
    EOS
  end

  test do
    system Formula["python@3.12"].opt_bin"python3.12", "-c", "import vapoursynth"
    system bin"vspipe", "--version"
  end
end