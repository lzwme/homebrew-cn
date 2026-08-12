class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://ghfast.top/https://github.com/vapoursynth/subtext/archive/refs/tags/R6.tar.gz"
  sha256 "536e2f056c7b318b0104b8b9050bb17c00d8ca60b0e5fdecf1ee92879c5f9165"
  license "MIT"
  revision 2
  version_scheme 1
  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f56f0a10b08f066c5909a4273f0a986e40081291eb107abe9d79ff51cf67a5e1"
    sha256 cellar: :any, arm64_sequoia: "eaf9bea7b6a8acc2d51a31e9ea67107ebc6dc0d12c35eca8bbc919365fbc5fc6"
    sha256 cellar: :any, arm64_sonoma:  "6a8c5478e72add6ca4c8b7450820d1e73ead6f91354b5000a2fa5f6f8880442e"
    sha256 cellar: :any, sonoma:        "5f75a967dca0985a69441ff1be78350f69ebbf9480d52a6c3c7255454eb9474b"
    sha256               arm64_linux:   "7a60dac36d34316d9b2d6105cf7c76b918a8f133236ac2e876024ba135b6470e"
    sha256               x86_64_linux:  "b4af8d5b051d336e07eefddacea443225381f3e6ea80803c079709ee13425b43"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "python@3.14"
  depends_on "vapoursynth"

  def python3 = "python3.14"

  def install
    # Work around Homebrew's python prefix patch
    args = %W[-Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", "from vapoursynth import core; core.sub"
  end
end