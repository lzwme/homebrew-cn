class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.4.1/SFCGAL-v1.4.1.tar.gz"
  sha256 "1800c8a26241588f11cddcf433049e9b9aea902e923414d2ecef33a3295626c3"
  license "LGPL-2.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5d6e4ad71e25a5e58f54505749378852c6bc63488d4ae4b5c1e5eac71e23324"
    sha256 cellar: :any,                 arm64_ventura:  "8b5a7b82c65cd6916c06e0bddc5c2c6b594ee1ac4f772af78b4b66ad9c6f999d"
    sha256 cellar: :any,                 arm64_monterey: "d699cd167ddd41aa8a19939812420515168c57a826c9b2beefecb8921d9b044a"
    sha256 cellar: :any,                 sonoma:         "433739850305ab3c56a876be71ff4c2acd3eb6eabc30a90aa7442e870d0770f9"
    sha256 cellar: :any,                 ventura:        "809115aeb7e79a69922c16210fff18725ecda80aac01ff6cd5359bb249b2e357"
    sha256 cellar: :any,                 monterey:       "8eb91b8d88f001cdf308730331de331e182441072fc24750753f220313142c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e5f0fef7da5fd9c79d5c55e10e3cb4fd4b09838ceeb9d03a09f073c60bfef3"
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