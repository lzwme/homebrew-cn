class VapoursynthBm3d < Formula
  desc "BM3D denoising filter for VapourSynth"
  homepage "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D"
  url "https://files.pythonhosted.org/packages/5b/16/6f1d0e05ceff921106281db6866d45e1b7eb284f078886e463ca9a1e6566/vapoursynth_bm3d-11.0.tar.gz"
  sha256 "a1d02dd4bf7e2b5bfaa2b3c6744e5093b225e8562a39d183a6ba239554cd876c"
  license "MIT"
  revision 1
  head "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a4568f68ca8028edd94f823ce6fc149deaecc07d5525e59a820e2e0559a24b19"
    sha256 cellar: :any, arm64_tahoe:       "faee395d92887023f61a9f96cd847fcd26d30944f2d45422773e6e51dd06cd9d"
    sha256 cellar: :any, arm64_sequoia:     "8e9ca5540ef744fc1fc3270584e999400f87787f1a2caf5dc60ed104cc9a9938"
    sha256 cellar: :any, arm64_linux:       "c871181495a457b365302de4ceb4e38b693052790a6313a8a9e9e837f794572e"
    sha256 cellar: :any, x86_64_linux:      "9e31dd2395507d12c6cfa185f52fc066a034b5991dece3f2e84edab649ab2860"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "python@3.15"
  depends_on "vapoursynth"

  deny_network_access!

  def install
    (buildpath/"python.ini").write "[binaries]\npython = '#{python3}'\n"

    # Work around Homebrew's python prefix patch
    args = %W[
      --native-file=python.ini
      -Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import vapoursynth as vs
      clip = vs.core.std.BlankClip(width=32, height=32, format=vs.GRAYS, length=1, color=[0.25])
      filtered = vs.core.bm3d.Basic(clip, sigma=[3])
      frame = filtered.get_frame(0)
      assert frame.width == 32 and frame.height == 32
      assert abs(frame[0][0, 0] - 0.25) < 1e-6
    PYTHON
  end
end