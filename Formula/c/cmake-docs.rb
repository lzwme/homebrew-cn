class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.31.0cmake-3.31.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.31.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.31.0.tar.gz"
  sha256 "300b71db6d69dcc1ab7c5aae61cbc1aa2778a3e00cbd918bc720203e311468c3"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8af90da09a101868960c61ac9effc43214eb959ef8f12131185d81de86356d20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8af90da09a101868960c61ac9effc43214eb959ef8f12131185d81de86356d20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8af90da09a101868960c61ac9effc43214eb959ef8f12131185d81de86356d20"
    sha256 cellar: :any_skip_relocation, sonoma:        "12d7979bebc6cf6823940288cfe09f04cafe168c38f3656365d8400fc0a5d854"
    sha256 cellar: :any_skip_relocation, ventura:       "12d7979bebc6cf6823940288cfe09f04cafe168c38f3656365d8400fc0a5d854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8af90da09a101868960c61ac9effc43214eb959ef8f12131185d81de86356d20"
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