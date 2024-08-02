class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v1.5.2/SFCGAL-v1.5.2.tar.gz"
  sha256 "b946b3c20d53f6e2703046085f0fcfea6c1a4081163f7bedd30b1195801efdd2"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c908273d1811257870249120736e96ebf2d93bea5f1a89aa5d8933b472bb450d"
    sha256 cellar: :any,                 arm64_ventura:  "bd183913b552c7359bfb6f64142ea91db1bf21151cbea9ec5e0ec3a54ccb4273"
    sha256 cellar: :any,                 arm64_monterey: "797a52c9caa6c5eea1c6a5daa5e6fd520d5eb37d25765d62750c424dcbe7b8aa"
    sha256 cellar: :any,                 sonoma:         "6c7b5ffe8988622946db8e11c2fc8862784c12db0dad85b0769528072b78838c"
    sha256 cellar: :any,                 ventura:        "94a033c3dc429b82e2dad3ddb9107e51a2d2071f111bcf6690be26e111602d67"
    sha256 cellar: :any,                 monterey:       "4d5e9f0f2645dd374abcc700ea03ae4eb31f4cf4b73178a61b2c0c4252640d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87853456acd8ae85c55ce5643cbdaa1058325f9eca97ff4ff0db7c8b95a7bed5"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  # error: array must be initialized with a brace-enclosed initializer
  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end