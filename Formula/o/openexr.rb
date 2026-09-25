class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "0dc41a9dd84c868ad89c892382f75f6835a73decbefab9366d6f168bf9322954"
  license "BSD-3-Clause"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "21221824bb1dadce8c0475e2d85e8a8417c107534d8005946b7b4e570161fc5d"
    sha256 cellar: :any, arm64_tahoe:       "20866ecd17e961809f35cb0bf46250db10b4a50fef9a641d9df6f6c707851610"
    sha256 cellar: :any, arm64_sequoia:     "6ffb7d151ad21353abf58aac24b808c7a39106d904789b7de6ddaebe76ab46b4"
    sha256 cellar: :any, arm64_linux:       "1c31c827cb0020c7bc184a884fbb39bab4638b52221427c4abbd29844c6f5d8e"
    sha256 cellar: :any, x86_64_linux:      "f5dcea57e7a0c8daa22efacd3a0bb457420c3769d560956a140c1472737b72d4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"
  depends_on "zstd"

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