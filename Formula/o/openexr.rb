class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.13.tar.gz"
  sha256 "1ed0cee48ac8c77da235c8ca8ab85d031d43cd790eda36af87fed4cf316cf2df"
  license "BSD-3-Clause"
  revision 2
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "066bbfc08092dbf132dba191d2daaabbb23c01756a47e22e32c120245521f9f9"
    sha256 cellar: :any, arm64_sequoia: "ddb1ac6f66f77b2866d5be4984c4080a37cd97bc73ebe0cfad6b8352c20ea6f9"
    sha256 cellar: :any, arm64_sonoma:  "58f067a2a7c29afa499f7540a09656a35ecabb9c21e06c9cb0295b41b46eaa9a"
    sha256 cellar: :any, sonoma:        "b40ea23dd0915261bc46a010f2024899277d8e79a4c99178b8ba3d4ad765e4a8"
    sha256 cellar: :any, arm64_linux:   "10f1b5db0d033746fcb26c1eb7af1c20ccdd64c8fcdf741c944de72ff4a0a215"
    sha256 cellar: :any, x86_64_linux:  "f06d43e4412c185c969e85589546ebb388bdf07e145eacd58d123c252cd6fb6a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-exr" do
      url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
      sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
    end

    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end