class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.13.tar.gz"
  sha256 "1ed0cee48ac8c77da235c8ca8ab85d031d43cd790eda36af87fed4cf316cf2df"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "529898adaffa9907550b288da1e0bba6f2494dbba75c9f89969b54eecfe6a452"
    sha256 cellar: :any, arm64_sequoia: "56dcf4d80186c78d94310f76f4e792fb5ad27d3d939400bbe85ff21c35b33cfe"
    sha256 cellar: :any, arm64_sonoma:  "2e2d593988653aa693c99d7a68324ea41daaaabf3a647cfff2dfa6d6ff240560"
    sha256 cellar: :any, sonoma:        "7a7e29d83fd49954171591d242bfacc7ca5ee928d2a610b906d2da6072019549"
    sha256 cellar: :any, arm64_linux:   "d76d649f2fc2019ed4bb41dcee1e5b72fd17a181c7fa36458faf27de7cd3fc88"
    sha256 cellar: :any, x86_64_linux:  "cd7c4e82c9cba59dabcee49701c0ff7068e68ff23d8ffeefb9d4f9134cff7209"
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