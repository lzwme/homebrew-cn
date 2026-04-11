class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://ghfast.top/https://github.com/dubhater/vapoursynth-mvtools/archive/refs/tags/v25.tar.gz"
  sha256 "378c94e1b742a55b272c69cef52e88c999e840365a1e96ac3856dd23e738121c"
  license "GPL-2.0-or-later"
  head "https://github.com/dubhater/vapoursynth-mvtools.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4e6833bbed941bef288dba7267f81f4bd2663da1c0cda951401e5ac27d9e342e"
    sha256 cellar: :any, arm64_sequoia: "92957e9af09dc5821be4f6dea5b430093fb9065479ba726733e442b837ecd002"
    sha256 cellar: :any, arm64_sonoma:  "e338abd1e74719cab13654d2f5de1cb09dbb71a2680bece9955fa6655ef96077"
    sha256 cellar: :any, sonoma:        "a61d1fbb50dca72618ddc7dfc9164ec0a60abd81c0a2827202de81452963ba23"
    sha256               arm64_linux:   "98d0e2494a91284a111ca3719796eb2661c449a8945ee7cd586ee091654b1c12"
    sha256               x86_64_linux:  "245f16c3ae79b84b2f16508456084a79be2765470eee56832a3a4c37e8d5554e"
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "vapoursynth"

  def install
    # Replace vendored path to homebrew formula path
    inreplace "meson.build", "'vapoursynth/include'", "'#{Formula["vapoursynth"].opt_include}/vapoursynth'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      MVTools will not be autoloaded in your VapourSynth scripts. To use it
      use the following code in your scripts:

        vs.core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/#{shared_library("libmvtools")}")
    EOS
  end

  test do
    script = <<~PYTHON.split("\n").join(";")
      import vapoursynth as vs
      vs.core.std.LoadPlugin(path="#{lib/shared_library("libmvtools")}")
    PYTHON
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", script
  end
end