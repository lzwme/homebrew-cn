class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https:www.vapoursynth.com"
  url "https:github.comvapoursynthvapoursyntharchiverefstagsR70.tar.gz"
  sha256 "59c813ec36046be33812408ff00e16cae63c6843af6acf4e34595910a80e267b"
  license "LGPL-2.1-or-later"
  head "https:github.comvapoursynthvapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(^R(\d+(?:\.\d+)*?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d79f8ef83d94a4907c14c9668e624534fae85e2147686399469c278d84acd1ea"
    sha256 cellar: :any,                 arm64_sonoma:  "2985dc4e9fadc09e1a4825b05f03991bdc79fc63ff94eab0365a6303874a2fbf"
    sha256 cellar: :any,                 arm64_ventura: "217af49cb954058882ed4a217f60986dc8337c31376999dadd1d593f429d2ab5"
    sha256 cellar: :any,                 sonoma:        "df39bdc45b16212157ebb877649347b095a8c91340a0595e84a130df0c727790"
    sha256 cellar: :any,                 ventura:       "d66ea7ba907f9e2b76e81cc0d470780303159963b75da3b25a454e67e6b791d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4601aed6b1236828233e683bc442f8b8f64adf18c26b2324e4b64e52c7255ea0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"
  depends_on "zimg"

  # std::to_chars requires at least MACOSX_DEPLOYMENT_TARGET=13.3
  # so it is possible to avoid LLVM dependency on Ventura but the
  # bottle would have issues if system was on macOS 13.2 or older.
  on_ventura :or_older do
    depends_on "llvm"
    fails_with :clang
  end

  fails_with gcc: "5"

  def install
    if OS.mac? && MacOS.version <= :ventura
      ENV.llvm_clang
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}c++"
    end

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