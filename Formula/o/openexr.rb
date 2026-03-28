class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.8.tar.gz"
  sha256 "0dd8d50e7f04219f3f925702564e994f9acdc6133ba537ec75eb6208119bec33"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfbdb38f72815525272aea46da9426f3327ae150a6d0231f52e45a9e68a6c340"
    sha256 cellar: :any,                 arm64_sequoia: "dc92aaa1ea00840f10eff2c13a94b14f24a528461cb211758cd344ec56ae6256"
    sha256 cellar: :any,                 arm64_sonoma:  "91da5a80b368edc312dde7380fd06255f416155d4f66bd50dabd30d11d1e61c2"
    sha256 cellar: :any,                 sonoma:        "675b934e36dc76392ad3c3921eb046e5e4acfc798e00c402cf9c5acc31c5a1cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eebb08283ef5071ba386b0e45926a6169e013333e20b9fd6841719e83aeac23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66308c444801a3d060c2511b7088678336cd58ac3bc6d7a2191137ae62e25584"
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