class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.12.tar.gz"
  sha256 "a455779c389f65c64220d45b63ead2900081e5f6337cdf93431cb1032c3e2686"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc1df7d35bd6a8f40732706bb725a777be6f430b1b128c64bc4716eca9e090c1"
    sha256 cellar: :any, arm64_sequoia: "005ffa4f3d465e3b853e36738d6b84affed5f1b75041aa8ba3ed4f7f8a056f43"
    sha256 cellar: :any, arm64_sonoma:  "93c9f141582218c51eb62c9ea78020faf7431d706caae2e56c239b1dbe6d1002"
    sha256 cellar: :any, sonoma:        "c0bf92c25f1011a1f7d23b933c5041a0f5acb61453b49a075ea3e30cff10c754"
    sha256 cellar: :any, arm64_linux:   "1dc91c24b79da658c330392b4d879ec7adc6eaab57ba6cc66f5ce83b908b13b2"
    sha256 cellar: :any, x86_64_linux:  "99c01f298b2209238ddeffb8405c9bbe3347cdb0b44a93fe5ac3a1d09ca88fd5"
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