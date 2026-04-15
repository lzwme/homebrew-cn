class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.9.tar.gz"
  sha256 "328c6fcd794b2538d71c65b401264e6745cf65cbc18f404e55ec3c0230d2373c"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e405198ae7ffca3f0351ce0034f3999e2999144ce90bcd835555a6692d576f0a"
    sha256 cellar: :any,                 arm64_sequoia: "0d13047a9e13e1072022f768e72e3e02301c5130c94bab0d98eb3a630cff1342"
    sha256 cellar: :any,                 arm64_sonoma:  "8f928528c26dd6c2261b0fcb2e1f9540190e8dfeba9f45187904e11659353800"
    sha256 cellar: :any,                 sonoma:        "6e55a789dd2803fb9c1e8fbf5274ca878aa97e24562a937b3fd097f074c2dfe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45dcfe858e29b26fa5f50661cf25f08215852867829c537ac3ef4937df175a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28566e5b9a3cb9006cc0e9e6aa3cfbcf0b5eaa7245ffd882c2feedbe870b5c24"
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