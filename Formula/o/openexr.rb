class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "d7d38eb6a63ea8ba0f301d0ad6a80094032d488e9e6c525b35236d20a9ae3ef2"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c5b7795acc003e39dfcef4caf0d85396cb43edaa445851f3ca48153b2f7415a"
    sha256 cellar: :any,                 arm64_sequoia: "48f40a378fa099694bb97fcca9991637dd55b965f7b69e17b53af4bdf43a712f"
    sha256 cellar: :any,                 arm64_sonoma:  "35899159d0b1a11b18993fb619542fb64989e13141d92b0cd18c2ed6c1ed8fc0"
    sha256 cellar: :any,                 sonoma:        "c1c93e09abdcf85a8d7fdfd8a13f371596a5ab62176c370d7cbdb2de49104b43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "891b700419605561871244b6bf76137ee652903bd278f965f4c4805d36abd653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b673a100c9de00cef857aadd25077908d3518748ef99c26dfae73702c6fded2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"

  uses_from_macos "zlib"

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