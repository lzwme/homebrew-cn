class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.27.2/cmake-3.27.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.2.tar.gz"
  sha256 "798e50085d423816fe96c9ef8bee5e50002c9eca09fed13e300de8a91d35c211"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cf5f8e82a66772526f6456378c7b4e454cc4fd840e7ea8591dd07ecf35b0332"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cf5f8e82a66772526f6456378c7b4e454cc4fd840e7ea8591dd07ecf35b0332"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cf5f8e82a66772526f6456378c7b4e454cc4fd840e7ea8591dd07ecf35b0332"
    sha256 cellar: :any_skip_relocation, ventura:        "9f0a84e0ea94602e37a701b87f0139e8d58581adcea41088a78b0a5aa7c84f1e"
    sha256 cellar: :any_skip_relocation, monterey:       "9f0a84e0ea94602e37a701b87f0139e8d58581adcea41088a78b0a5aa7c84f1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f0a84e0ea94602e37a701b87f0139e8d58581adcea41088a78b0a5aa7c84f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cf5f8e82a66772526f6456378c7b4e454cc4fd840e7ea8591dd07ecf35b0332"
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