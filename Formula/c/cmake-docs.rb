class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv4.0.2cmake-4.0.2.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-4.0.2.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-4.0.2.tar.gz"
  sha256 "1c3a82c8ca7cf12e0b17178f9d0c32f7ac773bd5651a98fcfd80fbf4977f8d48"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18befc0d468df5072a1cacd64d34e0a8ec2ab515e3c7303712d50819538af840"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18befc0d468df5072a1cacd64d34e0a8ec2ab515e3c7303712d50819538af840"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18befc0d468df5072a1cacd64d34e0a8ec2ab515e3c7303712d50819538af840"
    sha256 cellar: :any_skip_relocation, sonoma:        "01011f228e4eee6a204848b92e7e148143020695407919e6137dfd21f0f05cd2"
    sha256 cellar: :any_skip_relocation, ventura:       "01011f228e4eee6a204848b92e7e148143020695407919e6137dfd21f0f05cd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18befc0d468df5072a1cacd64d34e0a8ec2ab515e3c7303712d50819538af840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18befc0d468df5072a1cacd64d34e0a8ec2ab515e3c7303712d50819538af840"
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