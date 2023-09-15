class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.27.5/cmake-3.27.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.5.tar.gz"
  sha256 "5175e8fe1ca9b1dd09090130db7201968bcce1595971ff9e9998c2f0765004c9"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa743aa983c36b91ccd02349848f251d8a5a1785697f6b413b0f16af42eb57b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa743aa983c36b91ccd02349848f251d8a5a1785697f6b413b0f16af42eb57b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa743aa983c36b91ccd02349848f251d8a5a1785697f6b413b0f16af42eb57b4"
    sha256 cellar: :any_skip_relocation, ventura:        "5b0c4176350ed6f922f508fc93662f3566aa29246376849f4543c46d331ed68f"
    sha256 cellar: :any_skip_relocation, monterey:       "5b0c4176350ed6f922f508fc93662f3566aa29246376849f4543c46d331ed68f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b0c4176350ed6f922f508fc93662f3566aa29246376849f4543c46d331ed68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa743aa983c36b91ccd02349848f251d8a5a1785697f6b413b0f16af42eb57b4"
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