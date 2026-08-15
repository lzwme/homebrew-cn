class VapoursynthSubtext < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://ghfast.top/https://github.com/vapoursynth/subtext/archive/refs/tags/R6.tar.gz"
  sha256 "536e2f056c7b318b0104b8b9050bb17c00d8ca60b0e5fdecf1ee92879c5f9165"
  license "MIT"
  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "26372740eb19ec352246857140e5721af85aa9c9183c362fe8917efb63216ef7"
    sha256 cellar: :any, arm64_sequoia: "502d10b2115e10744eb8869bf13ffa6f31b33b65ba778ec7601476f56f857d4f"
    sha256 cellar: :any, arm64_sonoma:  "c694902da7250d5520793f80a053184ee5867d88406995dd93739c8217145528"
    sha256 cellar: :any, sonoma:        "0db0d3607f4a4d978da1e4faae1cf6676b7d233ae3a695180378c31e8481792a"
    sha256               arm64_linux:   "a4219d268b6d4f8436b2d08bbb511b5351dac0b5f67364247a0cbf2522cee403"
    sha256               x86_64_linux:  "03df921bd9bf6fc6d9bfec17ee9ebb9050f9a7857b22e6551bea17ef148b9e86"
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