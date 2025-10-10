class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "0d75aa277c33a4ed1fce2e272126f2d8dbd01adda82d7cf4fe67b99f6f7eedce"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3738e25d89fc47be20189ac0a25ba15e139bce31ddb1ffc16edf9e91ee360767"
    sha256 cellar: :any,                 arm64_sequoia: "72f6f0c2ab1cfaac6df72d9df3d3de2052f33a9d4981db2641f9e38d017e5520"
    sha256 cellar: :any,                 arm64_sonoma:  "b717768d29cd65ef11d9056c88255f420631d0c90ea3d6d0908cd45ed3073aae"
    sha256 cellar: :any,                 sonoma:        "aee5976cb6164cf99b4b1f641f4df203638960d6c2ed9b14c6565039e0844f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c24c82b57d8ade9ee3c51c95317b36df5c0237819923378812ff18cc7c761f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6764dbc6efd995393941c85fe666d29c8851830aedbebf92808be1334fea7e98"
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