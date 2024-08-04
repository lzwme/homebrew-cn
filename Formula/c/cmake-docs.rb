class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.30.2cmake-3.30.2.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.30.2.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.30.2.tar.gz"
  sha256 "46074c781eccebc433e98f0bbfa265ca3fd4381f245ca3b140e7711531d60db2"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "057e01938eef056e88b448f4818a910916fca663e9b3dcc80533db4ff9a96988"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "057e01938eef056e88b448f4818a910916fca663e9b3dcc80533db4ff9a96988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "057e01938eef056e88b448f4818a910916fca663e9b3dcc80533db4ff9a96988"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2db811ac1baca6cbcc95c6f4663a677fcf8d40c23d6e19c28bf21ad10aab124"
    sha256 cellar: :any_skip_relocation, ventura:        "e2db811ac1baca6cbcc95c6f4663a677fcf8d40c23d6e19c28bf21ad10aab124"
    sha256 cellar: :any_skip_relocation, monterey:       "e2db811ac1baca6cbcc95c6f4663a677fcf8d40c23d6e19c28bf21ad10aab124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "057e01938eef056e88b448f4818a910916fca663e9b3dcc80533db4ff9a96988"
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