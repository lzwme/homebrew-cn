class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.30.3cmake-3.30.3.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.30.3.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.30.3.tar.gz"
  sha256 "6d5de15b6715091df7f5441007425264bdd477809f80333fdf95f846aaff88e4"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9eb73ba5dfd9421a57bf494530927d7efb1d7a8bc86aecb3957551214e9349c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eb73ba5dfd9421a57bf494530927d7efb1d7a8bc86aecb3957551214e9349c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eb73ba5dfd9421a57bf494530927d7efb1d7a8bc86aecb3957551214e9349c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eb73ba5dfd9421a57bf494530927d7efb1d7a8bc86aecb3957551214e9349c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0da27a1d17742a22294bbf2852a551271fd0e9f81d1e3d466c632f5bd592c376"
    sha256 cellar: :any_skip_relocation, ventura:        "0da27a1d17742a22294bbf2852a551271fd0e9f81d1e3d466c632f5bd592c376"
    sha256 cellar: :any_skip_relocation, monterey:       "0da27a1d17742a22294bbf2852a551271fd0e9f81d1e3d466c632f5bd592c376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eb73ba5dfd9421a57bf494530927d7efb1d7a8bc86aecb3957551214e9349c8"
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