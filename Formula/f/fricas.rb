class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://ghfast.top/https://github.com/fricas/fricas/archive/refs/tags/1.3.13.tar.gz"
  sha256 "7ae03c0f566c4b2bbbd6da1b02965e2a5492b1b8e4f8f2f1d1329c72d44e42a2"
  license "BSD-3-Clause"
  head "https://github.com/fricas/fricas.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c15b302c244c29f0e21c64585a2853b6f6986fe9e0647f0140cbde85ac14206e"
    sha256 cellar: :any,                 arm64_sequoia: "15fe335ba8d9905e994da7a2886078b9824848afca7c4259c436dc44b4768e74"
    sha256 cellar: :any,                 arm64_sonoma:  "433f376667cac07df1f484b26997c6992d3b7f6741f8d5241e4c21d3ec5ee7a1"
    sha256 cellar: :any,                 sonoma:        "71707c3e44dff85ebba85e391fc62f5684155b8342347daa90cb97e775b767ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c64425203945bb32a826e1606d413c67a36ed3d0492fa8e00aeebc8d2e6595c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "996a712fd6b8adf2e075d4fbb3a3fe9a88f6805e84aa563f4947aac5612e7e6a"
  end

  depends_on "gmp"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxdmcp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "sbcl"
  depends_on "zstd"

  def install
    args = [
      "--with-lisp=sbcl",
      "--enable-lisp-core",
      "--enable-gmp",
    ]

    mkdir "build" do
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output("#{bin}/fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
  end
end