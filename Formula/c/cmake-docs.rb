class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.31.1cmake-3.31.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.31.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.31.1.tar.gz"
  sha256 "c4fc2a9bd0cd5f899ccb2fb81ec422e175090bc0de5d90e906dd453b53065719"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8d99611b3c73c44294b0875666f6c2121595fa72cb5a3a446a7b3b68fca61b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8d99611b3c73c44294b0875666f6c2121595fa72cb5a3a446a7b3b68fca61b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8d99611b3c73c44294b0875666f6c2121595fa72cb5a3a446a7b3b68fca61b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5560c9a973964b495458aaa51d89990dd5d932ba8fdc91b515c37fce29df4786"
    sha256 cellar: :any_skip_relocation, ventura:       "5560c9a973964b495458aaa51d89990dd5d932ba8fdc91b515c37fce29df4786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8d99611b3c73c44294b0875666f6c2121595fa72cb5a3a446a7b3b68fca61b7"
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