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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26ada5b2ce6c1b2a939b0168c23929cf1547a77fb4af679ad757b5b4b57a2f71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ada5b2ce6c1b2a939b0168c23929cf1547a77fb4af679ad757b5b4b57a2f71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26ada5b2ce6c1b2a939b0168c23929cf1547a77fb4af679ad757b5b4b57a2f71"
    sha256 cellar: :any_skip_relocation, sonoma:        "f12a62fced3ba55d4756f0286e49cce88a28c8c9cff6301cfb798ad77d481b3d"
    sha256 cellar: :any_skip_relocation, ventura:       "f12a62fced3ba55d4756f0286e49cce88a28c8c9cff6301cfb798ad77d481b3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26ada5b2ce6c1b2a939b0168c23929cf1547a77fb4af679ad757b5b4b57a2f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26ada5b2ce6c1b2a939b0168c23929cf1547a77fb4af679ad757b5b4b57a2f71"
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