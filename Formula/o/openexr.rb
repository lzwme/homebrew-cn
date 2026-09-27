class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "61559d6d0657f228f8dd5e3165ed6b74437b95e81849ad41c6d3493c0c144c1d"
  license "BSD-3-Clause"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d80f993967563d134b024535342ddb3a6927fc35ad072f6daf3e232a14ffa059"
    sha256 cellar: :any, arm64_tahoe:       "20c4b556ad6444bf7ef1a357606e6007d6b7d159d2dd959b4e3ab233368d9d55"
    sha256 cellar: :any, arm64_sequoia:     "54d914899278f9e5fe7dcad1559a33b65ab22e10c73b475c625ad4cd6da9cdda"
    sha256 cellar: :any, arm64_linux:       "204a7ec113a2e56464a1a912558576cd22caafb7b873f31e28c8d182bf7a88dd"
    sha256 cellar: :any, x86_64_linux:      "88c5d5e602932a43f1363dec2b6c39af6d2fb6f4682e9219c2a439a4f453c40e"
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