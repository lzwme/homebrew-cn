class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://ghfast.top/https://github.com/Kitware/CMake/releases/download/v4.4.5/cmake-4.4.5.tar.gz"
  sha256 "a0c54c88abb8078dd8eccadb717fc6bb194bf18e7d44c86309910288886e04e2"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9a8ab5fab29c0d76ebe588f0033cc9041be287b66a838528866d104cc7e210c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9a8ab5fab29c0d76ebe588f0033cc9041be287b66a838528866d104cc7e210c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9a8ab5fab29c0d76ebe588f0033cc9041be287b66a838528866d104cc7e210c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7432b7e2bf9070ce5334e7dc4ea73ca71980508c0a4a811e8966b2099590c087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7432b7e2bf9070ce5334e7dc4ea73ca71980508c0a4a811e8966b2099590c087"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  deny_network_access!

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