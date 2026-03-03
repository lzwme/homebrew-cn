class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.6.tar.gz"
  sha256 "f8cfe743a81c8cc1dd3cbaafa7fa76f75ad31456b0fc45a42b086d12530a4e35"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09aa9122bfb7a93265cf66ca507baaab4e4679ddae079b4922688fccaca7ee61"
    sha256 cellar: :any,                 arm64_sequoia: "fb2231bb584eb5aa789f6c4240b4aed018b5bfd63b693e9d0f11a15de644c5d3"
    sha256 cellar: :any,                 arm64_sonoma:  "423446d4a6fc6f94d344e6af73156f3052edcd4a67ce11b3e64c40142f273740"
    sha256 cellar: :any,                 sonoma:        "80049c068ebce6eae9b1d7d2fa185123909b89fd4eee9239d3c47b67f00f8833"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93ef00632a5fc266b17fded26b4c84a25770f1951cb9df59a2a40c4239aade29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1285e286c7f7c9cfe0ba311dbabe169b92541219f917362419641b0b2c5b6a58"
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