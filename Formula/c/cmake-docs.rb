class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.29.0cmake-3.29.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.29.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.29.0.tar.gz"
  sha256 "a0669630aae7baa4a8228048bf30b622f9e9fd8ee8cedb941754e9e38686c778"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "086bc74089394fab8289f533aa553863841756204cd16c7d343675f878e97db7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "086bc74089394fab8289f533aa553863841756204cd16c7d343675f878e97db7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "086bc74089394fab8289f533aa553863841756204cd16c7d343675f878e97db7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9338efad236b57949eab0bb30312172a153eb15932985148815b3bd0dad5fc6a"
    sha256 cellar: :any_skip_relocation, ventura:        "9338efad236b57949eab0bb30312172a153eb15932985148815b3bd0dad5fc6a"
    sha256 cellar: :any_skip_relocation, monterey:       "9338efad236b57949eab0bb30312172a153eb15932985148815b3bd0dad5fc6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "086bc74089394fab8289f533aa553863841756204cd16c7d343675f878e97db7"
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