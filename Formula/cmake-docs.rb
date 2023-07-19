class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.27.0/cmake-3.27.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.0.tar.gz"
  sha256 "aaeddb6b28b993d0a6e32c88123d728a17561336ab90e0bf45032383564d3cb8"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c7de62cceaf0e4399c94285841c05a0f0f08ba5c7e43362ff184c215fbf5895"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c7de62cceaf0e4399c94285841c05a0f0f08ba5c7e43362ff184c215fbf5895"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c7de62cceaf0e4399c94285841c05a0f0f08ba5c7e43362ff184c215fbf5895"
    sha256 cellar: :any_skip_relocation, ventura:        "3b63e737b09da6f7c7a3aaeb51ce60c7198fa1bb66f2b14126961f2d8f95ffa7"
    sha256 cellar: :any_skip_relocation, monterey:       "3b63e737b09da6f7c7a3aaeb51ce60c7198fa1bb66f2b14126961f2d8f95ffa7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b63e737b09da6f7c7a3aaeb51ce60c7198fa1bb66f2b14126961f2d8f95ffa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918f8b2bc087667165578341e2cd64b360743a77b5b5b07781c6cf480eedbf74"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *std_cmake_args,
                                                             "-DCMAKE_DOC_DIR=share/doc/cmake",
                                                             "-DCMAKE_MAN_DIR=share/man",
                                                             "-DSPHINX_MAN=ON",
                                                             "-DSPHINX_HTML=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end