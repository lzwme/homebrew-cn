class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "https:www.vapoursynth.com"
  url "https:github.comvapoursynthvs-ocrarchiverefstagsR3.tar.gz"
  sha256 "e9da11b7f5f3e4acfee5890729769217aa5b385bb573cb303c2661d8d8a83712"
  license "MIT"
  version_scheme 1
  head "https:github.comvapoursynthvs-ocr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "59e7198e55f020269ef5dba9f54c07b67c5a789379df455ec634e6b236a129b0"
    sha256 cellar: :any,                 arm64_sonoma:  "780ee3e48072500cbe2847c42e301fae220ec8a6d5cb2104c5c43cecc7a7feb7"
    sha256 cellar: :any,                 arm64_ventura: "cd5724d21e95a31025bf0d0bad580406d2b3921a1afbd0778a3fafe123809b70"
    sha256 cellar: :any,                 sonoma:        "2106c78c52a64e3dee5fffaf924358216e2a4d962614d47dc1055721d0e535fe"
    sha256 cellar: :any,                 ventura:       "04e3d8edb77293bb176d2757f36ad28deb8d1c4fd571c7de3a95e04395ed731f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba3f2ce6d29c86e69853b445c6b8a4a4f95c26f88dc7e3947ecea9845009882"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "tesseract"
  depends_on "vapoursynth"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
      "install_dir : join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth')",
      "install_dir : '#{lib}vapoursynth'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(^python@\d\.\d+$) }
                                   .to_formula
                                   .opt_libexec"binpython"
    system python, "-c", "from vapoursynth import core; core.ocr"
  end
end