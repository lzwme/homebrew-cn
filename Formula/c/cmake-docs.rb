class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.30.1cmake-3.30.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.30.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.30.1.tar.gz"
  sha256 "df9b3c53e3ce84c3c1b7c253e5ceff7d8d1f084ff0673d048f260e04ccb346e1"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af347d17b30ae3483540551b9d8913c95edf26604ee4dad0bd07a67d1999d928"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af347d17b30ae3483540551b9d8913c95edf26604ee4dad0bd07a67d1999d928"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af347d17b30ae3483540551b9d8913c95edf26604ee4dad0bd07a67d1999d928"
    sha256 cellar: :any_skip_relocation, sonoma:         "c18fc06ff4982d63c3a75910cb8b186028f3992b16a6f548639753ed11e273a6"
    sha256 cellar: :any_skip_relocation, ventura:        "50bab0d7d3aa1a9ddc61ddcf42a70bce1b6bd68933c67b11fed86e51f23a155d"
    sha256 cellar: :any_skip_relocation, monterey:       "50bab0d7d3aa1a9ddc61ddcf42a70bce1b6bd68933c67b11fed86e51f23a155d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af347d17b30ae3483540551b9d8913c95edf26604ee4dad0bd07a67d1999d928"
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