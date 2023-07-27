class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.27.1/cmake-3.27.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.1.tar.gz"
  sha256 "b1a6b0135fa11b94476e90f5b32c4c8fad480bf91cf22d0ded98ce22c5132004"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4ee7ee1ac692a489de148d18f030b5db2589bd6e09d3a479a268b20f5f0d1af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4ee7ee1ac692a489de148d18f030b5db2589bd6e09d3a479a268b20f5f0d1af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4ee7ee1ac692a489de148d18f030b5db2589bd6e09d3a479a268b20f5f0d1af"
    sha256 cellar: :any_skip_relocation, ventura:        "f0e6f1af63c3c884a45292864c37e31898e6d731a921e6225fae6760e87a7545"
    sha256 cellar: :any_skip_relocation, monterey:       "f0e6f1af63c3c884a45292864c37e31898e6d731a921e6225fae6760e87a7545"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0e6f1af63c3c884a45292864c37e31898e6d731a921e6225fae6760e87a7545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "512dd02ad1f9397ed031f71acb1517cb3384acaeaf42fad62ccbfb7995c1ee2b"
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