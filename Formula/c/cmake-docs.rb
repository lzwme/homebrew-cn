class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.31.6cmake-3.31.6.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.31.6.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.31.6.tar.gz"
  sha256 "653427f0f5014750aafff22727fb2aa60c6c732ca91808cfb78ce22ddd9e55f0"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a894fcab9dc2fb9ebddcc116c53d069ad202a44fdc6017f2a4271f398ff9c651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a894fcab9dc2fb9ebddcc116c53d069ad202a44fdc6017f2a4271f398ff9c651"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a894fcab9dc2fb9ebddcc116c53d069ad202a44fdc6017f2a4271f398ff9c651"
    sha256 cellar: :any_skip_relocation, sonoma:        "5688bd834d37c604800accda35ac9b9764be0e24e5be40dbd3978b9fda2aa539"
    sha256 cellar: :any_skip_relocation, ventura:       "5688bd834d37c604800accda35ac9b9764be0e24e5be40dbd3978b9fda2aa539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a894fcab9dc2fb9ebddcc116c53d069ad202a44fdc6017f2a4271f398ff9c651"
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