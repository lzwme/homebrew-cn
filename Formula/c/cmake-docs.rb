class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://ghfast.top/https://github.com/Kitware/CMake/releases/download/v4.1.0/cmake-4.1.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.1.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.1.0.tar.gz"
  sha256 "81ee8170028865581a8e10eaf055afb620fa4baa0beb6387241241a975033508"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c6ea6fdefe538c7a1f59a2722745e9550e1c755af1560813ef5327b5194d7d6b"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DCMAKE_DOC_DIR=share/doc/cmake
      -DCMAKE_MAN_DIR=share/man
      -DSPHINX_MAN=ON
      -DSPHINX_HTML=ON
    ]
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end