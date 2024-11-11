class Nlopt < Formula
  desc "Freeopen-source library for nonlinear optimization"
  homepage "https:nlopt.readthedocs.io"
  url "https:github.comstevengjnloptarchiverefstagsv2.9.0.tar.gz"
  sha256 "6e899e297485e457ec1bf84844de29921aeef674f9d5caf60277df45dca6ff76"
  license "MIT"
  head "https:github.comstevengjnlopt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf554c611a6bc268c2faa7cd6659b6e6047f2b47ac550cc90c41185221b14e86"
    sha256 cellar: :any,                 arm64_sonoma:  "f50f5763c8bf4e0cd452130c9338e7479f895eafc982dd1f2e7d06f723bd45ff"
    sha256 cellar: :any,                 arm64_ventura: "5ab38a026fa76cd19df9e0eeda96f7792a7d851c596b1bd1be8884814256aec1"
    sha256 cellar: :any,                 sonoma:        "85eac9d6647bb9b0231f73c5423a44914f815aeed4cbb15356e28fa6844a5a7d"
    sha256 cellar: :any,                 ventura:       "63051104fb0de336dbf5bbbbff79ee61d41b60ea5dc59b0c9628a60b8ce0fdd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e49dd81f4bb02c9efcbe4431b520e5f8c8791f2041085309024e5d72e5d3524"
  end

  depends_on "cmake" => [:build, :test]

  def install
    args = %w[
      -DNLOPT_GUILE=OFF
      -DNLOPT_MATLAB=OFF
      -DNLOPT_OCTAVE=OFF
      -DNLOPT_PYTHON=OFF
      -DNLOPT_SWIG=OFF
      -DNLOPT_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "testbox.c"
  end

  test do
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.0)
      project(box C)
      find_package(NLopt REQUIRED)
      add_executable(box "#{pkgshare}box.c")
      target_link_libraries(box NLopt::nlopt)
    CMAKE
    system "cmake", "."
    system "make"
    assert_match "found", shell_output(".box")
  end
end