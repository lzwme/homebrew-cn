class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.30.4cmake-3.30.4.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.30.4.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.30.4.tar.gz"
  sha256 "c759c97274f1e7aaaafcb1f0d261f9de9bf3a5d6ecb7e2df616324a46fe704b2"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12db91622e0f403505b494430a45cbbb544c2a4bc4b9c6632bdeba7266ea6768"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12db91622e0f403505b494430a45cbbb544c2a4bc4b9c6632bdeba7266ea6768"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12db91622e0f403505b494430a45cbbb544c2a4bc4b9c6632bdeba7266ea6768"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab57803fa84f34c4b41f05fa772f1ab8cf6226ac21011775e989f9f466b4b55"
    sha256 cellar: :any_skip_relocation, ventura:       "7ab57803fa84f34c4b41f05fa772f1ab8cf6226ac21011775e989f9f466b4b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12db91622e0f403505b494430a45cbbb544c2a4bc4b9c6632bdeba7266ea6768"
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