class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://ghfast.top/https://github.com/Kitware/CMake/releases/download/v4.2.2/cmake-4.2.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.2.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.2.2.tar.gz"
  sha256 "bbda94dd31636e89eb1cc18f8355f6b01d9193d7676549fba282057e8b730f58"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "672e22b1ed74ee66801005a112f8497dc74395983a050bcdce0c3e6e1a4118f5"
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