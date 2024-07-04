class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.30.0cmake-3.30.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.30.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.30.0.tar.gz"
  sha256 "157e5be6055c154c34f580795fe5832f260246506d32954a971300ed7899f579"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "693015ab0b81a0e8d1f7e1c65ae8f6853734bb85da5facbdacec93899a8cf9b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "693015ab0b81a0e8d1f7e1c65ae8f6853734bb85da5facbdacec93899a8cf9b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "693015ab0b81a0e8d1f7e1c65ae8f6853734bb85da5facbdacec93899a8cf9b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7709705cf946a630dd9184c3d2d83ecf50ed68dcdb922fe97778ee6fa8cb98fb"
    sha256 cellar: :any_skip_relocation, ventura:        "7709705cf946a630dd9184c3d2d83ecf50ed68dcdb922fe97778ee6fa8cb98fb"
    sha256 cellar: :any_skip_relocation, monterey:       "439111ce5045a9961cf81cc2ed9e0f9fac2107e3c7607820ced9062f8e14bec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "693015ab0b81a0e8d1f7e1c65ae8f6853734bb85da5facbdacec93899a8cf9b6"
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