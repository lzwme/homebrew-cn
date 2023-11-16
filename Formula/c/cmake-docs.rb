class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.27.8/cmake-3.27.8.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.8.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.8.tar.gz"
  sha256 "fece24563f697870fbb982ea8bf17482c9d5f855d8c9bf0b82463d76c9e8d0cc"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fde84a543a1076c45e868c1de4620dc067276d274ac43a9c1eaab4883de41f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fde84a543a1076c45e868c1de4620dc067276d274ac43a9c1eaab4883de41f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fde84a543a1076c45e868c1de4620dc067276d274ac43a9c1eaab4883de41f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "db0464027d3ee06c433afd6a9e78d76758ca5a5913425eb70fc086f18aab67ab"
    sha256 cellar: :any_skip_relocation, ventura:        "db0464027d3ee06c433afd6a9e78d76758ca5a5913425eb70fc086f18aab67ab"
    sha256 cellar: :any_skip_relocation, monterey:       "db0464027d3ee06c433afd6a9e78d76758ca5a5913425eb70fc086f18aab67ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fde84a543a1076c45e868c1de4620dc067276d274ac43a9c1eaab4883de41f5"
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