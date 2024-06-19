class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.29.6cmake-3.29.6.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.29.6.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.29.6.tar.gz"
  sha256 "1391313003b83d48e2ab115a8b525a557f78d8c1544618b48d1d90184a10f0af"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e720005ed853d1c0fc2a16537b2e6567ff7199ba203267323e20f59c386b7258"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e720005ed853d1c0fc2a16537b2e6567ff7199ba203267323e20f59c386b7258"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e720005ed853d1c0fc2a16537b2e6567ff7199ba203267323e20f59c386b7258"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdb39e5e5e899031d1ab3bcc11495fde825da0ddbfebff5ee101dfca514e8600"
    sha256 cellar: :any_skip_relocation, ventura:        "cdb39e5e5e899031d1ab3bcc11495fde825da0ddbfebff5ee101dfca514e8600"
    sha256 cellar: :any_skip_relocation, monterey:       "cdb39e5e5e899031d1ab3bcc11495fde825da0ddbfebff5ee101dfca514e8600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e720005ed853d1c0fc2a16537b2e6567ff7199ba203267323e20f59c386b7258"
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