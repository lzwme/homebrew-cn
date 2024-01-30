class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.28.2cmake-3.28.2.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.28.2.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.28.2.tar.gz"
  sha256 "1466f872dc1c226f373cf8fba4230ed216a8f108bd54b477b5ccdfd9ea2d124a"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "405f81abf528da8ea1505e99421c089e327f3efcdb7e5257a63dbf130646c37c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "405f81abf528da8ea1505e99421c089e327f3efcdb7e5257a63dbf130646c37c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "405f81abf528da8ea1505e99421c089e327f3efcdb7e5257a63dbf130646c37c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3c417708045f0bea5335908ca09293f6fcc15d43bc8015f87b9737cf95eb090"
    sha256 cellar: :any_skip_relocation, ventura:        "d3c417708045f0bea5335908ca09293f6fcc15d43bc8015f87b9737cf95eb090"
    sha256 cellar: :any_skip_relocation, monterey:       "d3c417708045f0bea5335908ca09293f6fcc15d43bc8015f87b9737cf95eb090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "405f81abf528da8ea1505e99421c089e327f3efcdb7e5257a63dbf130646c37c"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cmake", "-S", "UtilitiesSphinx", "-B", "build", *std_cmake_args,
                                                             "-DCMAKE_DOC_DIR=sharedoccmake",
                                                             "-DCMAKE_MAN_DIR=shareman",
                                                             "-DSPHINX_MAN=ON",
                                                             "-DSPHINX_HTML=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share"doccmakehtml"
    assert_path_exists man
  end
end