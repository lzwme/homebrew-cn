class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "06494da42eb91c47265ffbad02d0c73cf65d8ad7f24683b801f34d842c4ecb6d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "229c88e8cdcd4a5c5f61a16eb916b0ae96252e488207fcd0a0c637f83c81fe71"
    sha256 cellar: :any,                 arm64_sequoia: "3a11bd94ee231d80ad15b599fc21c39b62c2c196dae1508ef49f711bb0be1f4b"
    sha256 cellar: :any,                 arm64_sonoma:  "66f0cbee5a2f99e9ea626454f69012f07d097b32f5d1d9e8b3ccd584a84b8d44"
    sha256 cellar: :any,                 sonoma:        "6b60da1e1ceea853b825eb68057441a08552edd920585640d267a1f3927cdf00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c266b07b6d85cfa3c473d5c43007752182bd5e7a747e8050ff05de561b2db097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0365c45bed3c97610307f86aa11e428cd2fa9d1ba7df6493e35295cc9f5d3c20"
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