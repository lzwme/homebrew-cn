class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.12.tar.gz"
  sha256 "a455779c389f65c64220d45b63ead2900081e5f6337cdf93431cb1032c3e2686"
  license "BSD-3-Clause"
  revision 2
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d0b5a323834dfdfd25787054fe3db4fb86857d7612dc551fdbd26096c859cd72"
    sha256 cellar: :any, arm64_sequoia: "97e7ae22a45e0f5f704be253aa9854fa1e70802a983b79c3e4f37edd4a063117"
    sha256 cellar: :any, arm64_sonoma:  "73487ff44046cc2fac74715807e766a5cd861ba79f6e8c7b45dd142fc39d71e8"
    sha256 cellar: :any, sonoma:        "24b5e7e70cf9207c645854b32bada271b5e7052c6e3d905a25ac1460cae32297"
    sha256 cellar: :any, arm64_linux:   "bb145a5af688b19b5f18334e2d80a755c6a345014aeb9a41ea6ca8d811463ab8"
    sha256 cellar: :any, x86_64_linux:  "73910415d6f6642d1e49d4ef4544b46a85a9670494324fdd681262e06c5e148d"
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