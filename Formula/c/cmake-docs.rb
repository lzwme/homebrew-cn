class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv4.0.0cmake-4.0.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-4.0.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-4.0.0.tar.gz"
  sha256 "ddc54ad63b87e153cf50be450a6580f1b17b4881de8941da963ff56991a4083b"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f0ad5aae0e1cbfdff948c658e6c9465bb799eb440839f91e52e0d0c4885d2c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f0ad5aae0e1cbfdff948c658e6c9465bb799eb440839f91e52e0d0c4885d2c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f0ad5aae0e1cbfdff948c658e6c9465bb799eb440839f91e52e0d0c4885d2c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e970439daa60a6817eab0cd00b786aead9b42745a798b02c666a6b100326cff"
    sha256 cellar: :any_skip_relocation, ventura:       "5e970439daa60a6817eab0cd00b786aead9b42745a798b02c666a6b100326cff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f0ad5aae0e1cbfdff948c658e6c9465bb799eb440839f91e52e0d0c4885d2c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f0ad5aae0e1cbfdff948c658e6c9465bb799eb440839f91e52e0d0c4885d2c7"
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