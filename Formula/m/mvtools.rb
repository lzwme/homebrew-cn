class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhatervapoursynth/vapoursynth-mvtools"
  url "https://ghfast.top/https://github.com/dubhatervapoursynth/vapoursynth-mvtools/archive/refs/tags/v27.tar.gz"
  sha256 "b3b93ae7243d91d058a2b101ca725b949350b3edf20c080a8735ab76993c9df8"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/dubhatervapoursynth/vapoursynth-mvtools.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "922c17ab994c1746bab6cadc6ad3c8bd322b1f095d03209693108f9bf1efbb45"
    sha256 cellar: :any, arm64_sequoia: "3732b0662adf7e50dc1cba54300f446889acdc3de29c2abfebfa6940fb709696"
    sha256 cellar: :any, arm64_sonoma:  "96eefb764fde2c1e3ddaae8f94d3423045788607600f55f92bcd03516042bf0e"
    sha256 cellar: :any, sonoma:        "a4248298ad37f853b77433101d0b21efda25bef404a6d8d48a682089245c0628"
    sha256               arm64_linux:   "547c0ccfe8af8b15ccfef0ae402c287a072a0c463dd570694b138f319db2cc65"
    sha256               x86_64_linux:  "89a9a36bb67e42393c38bc8d668265a1a3becff37c1681503386805fdac9f2be"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "python@3.14"
  depends_on "vapoursynth"

  on_intel do
    depends_on "nasm" => :build
  end

  def python3 = "python3.14"

  def install
    # Work around Homebrew's python prefix patch
    args = %W[-Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    script = <<~PYTHON.split("\n").join(";")
      import vapoursynth as vs
      vs.core.mv.Super(vs.core.std.BlankClip(format=vs.GRAY8))
    PYTHON
    system python3, "-c", script
  end
end