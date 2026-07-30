class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://ghfast.top/https://github.com/Kitware/CMake/releases/download/v4.4.1/cmake-4.4.1.tar.gz"
  sha256 "95d4721f3625fb0d9d6ca480dd59a46c84b4c157f7fadd2e9b179ef9c871174d"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed739b7a6a0a2cae978e41b9779e039ee991751d8520b8f6e738e93927cec5ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed739b7a6a0a2cae978e41b9779e039ee991751d8520b8f6e738e93927cec5ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed739b7a6a0a2cae978e41b9779e039ee991751d8520b8f6e738e93927cec5ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed739b7a6a0a2cae978e41b9779e039ee991751d8520b8f6e738e93927cec5ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f729881fab98b97239c7937c6b1a7298631b53934b4519281f5e5e86a6f173d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f729881fab98b97239c7937c6b1a7298631b53934b4519281f5e5e86a6f173d6"
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