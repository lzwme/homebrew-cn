class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.5.tar.gz"
  sha256 "b10f21d3f8ff3211eb1687a2e2bf7a79d361aec8dfaca1f9b79f3d70755b4f48"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2c7a731a33246bc190e6cb065ad315cd6d8f14fdf92e5a6115b5247ddc1df8d"
    sha256 cellar: :any,                 arm64_sequoia: "87fdf424951a35592f7b93f2b8d0b470270e23c356f11053591bda69e2791649"
    sha256 cellar: :any,                 arm64_sonoma:  "e7007bd0c636b2cbb56692a4e4f2892dc6d604272d996ffd7ba7eadf6bf3bd19"
    sha256 cellar: :any,                 sonoma:        "e075f6626b78592d5c8304eca600d7763b592ef06f0735bd334c6943d70c726b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29bf1829a95d305c46de3ee59b78c7ae1d3ac3f9edf60f58e5311c5d11f71acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08d476a542722036076a61bfc7982a9ed9149d2e004b50d7130cf31552e03c9c"
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