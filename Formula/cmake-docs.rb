class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.26.2/cmake-3.26.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.26.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.26.2.tar.gz"
  sha256 "d54f25707300064308ef01d4d21b0f98f508f52dda5d527d882b9d88379f89a8"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caaa9c488bb784bce055e038fab028f774d1fe481877e69fbc8dbe77027c1d82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caaa9c488bb784bce055e038fab028f774d1fe481877e69fbc8dbe77027c1d82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caaa9c488bb784bce055e038fab028f774d1fe481877e69fbc8dbe77027c1d82"
    sha256 cellar: :any_skip_relocation, ventura:        "d80d1d2dd45977f2c30680b9f33ec569b9325a654161b4a45ad5cfa4d39d2380"
    sha256 cellar: :any_skip_relocation, monterey:       "d80d1d2dd45977f2c30680b9f33ec569b9325a654161b4a45ad5cfa4d39d2380"
    sha256 cellar: :any_skip_relocation, big_sur:        "d80d1d2dd45977f2c30680b9f33ec569b9325a654161b4a45ad5cfa4d39d2380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caaa9c488bb784bce055e038fab028f774d1fe481877e69fbc8dbe77027c1d82"
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