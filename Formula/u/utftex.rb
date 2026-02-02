class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://ghfast.top/https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.29.tar.gz"
  sha256 "ee755fba8cad2022d42ec41177607afd669814137e239f60dea116166fc0136c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d7ab118d40d8ba2c41a0859d173aa3965487f77601e17b52fbf87d612e8785a"
    sha256 cellar: :any,                 arm64_sequoia: "1c06e3b8b3d9f07a0e3ad4beaf831a3abf17b9dbad2d737dc4a6d85b148dab97"
    sha256 cellar: :any,                 arm64_sonoma:  "8557d2cfd0acaf7d123e6547ebc9da348980cac3a228d6526a5f2b8a3b969763"
    sha256 cellar: :any,                 sonoma:        "cb4d728327b0bd56806b4bc29d300f9fdb21b00a10d6521ee293ff8f66659b2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5710be5d99b10f3eecea43b02c70e2d4d886bfafa4d5457d7ff01bf6dfba0419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88a96b9afe2a10cfdc3be938ec7840464a7299227744616c755d40839997d9f6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"utftex", "\\left(\\frac{hello}{world}\\right)"
  end
end