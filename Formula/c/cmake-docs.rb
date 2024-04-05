class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.29.1cmake-3.29.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.29.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.29.1.tar.gz"
  sha256 "7fb02e8f57b62b39aa6b4cf71e820148ba1a23724888494735021e32ab0eefcc"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed14202643ed9dcbdaba8d38de815debffcb6d46f8417343419fe988c5cd8af0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed14202643ed9dcbdaba8d38de815debffcb6d46f8417343419fe988c5cd8af0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed14202643ed9dcbdaba8d38de815debffcb6d46f8417343419fe988c5cd8af0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3b5c271be221ab24ced8cbf14e2170950b12755921c4bc99d9e27c4e6221374"
    sha256 cellar: :any_skip_relocation, ventura:        "c3b5c271be221ab24ced8cbf14e2170950b12755921c4bc99d9e27c4e6221374"
    sha256 cellar: :any_skip_relocation, monterey:       "c3b5c271be221ab24ced8cbf14e2170950b12755921c4bc99d9e27c4e6221374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed14202643ed9dcbdaba8d38de815debffcb6d46f8417343419fe988c5cd8af0"
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