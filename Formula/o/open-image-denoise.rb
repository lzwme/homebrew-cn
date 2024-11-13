class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https:openimagedenoise.github.io"
  url "https:github.comOpenImageDenoiseoidnreleasesdownloadv2.3.1oidn-2.3.1.src.tar.gz"
  sha256 "225879b4225bfe015273f0372bf6e7a69d01030043c8aefa017196b41ecf8148"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "9f64e80c1449ceb35fb8255a7e598584d822d00ebaf76d8d77ab4ca44b8735f0"
    sha256 cellar: :any, arm64_sonoma:  "9b1fead166634b11bcbe0433524253f1a4c132c7d9f84e045b88156a9a99248d"
    sha256 cellar: :any, arm64_ventura: "1366c44e78888e88a8b5225dc26a4f0ec5f9e56ce9660406e65b7efe6565895b"
    sha256 cellar: :any, sonoma:        "6267f407a2efe2129b7f28c3ee391e0c63f350883988b9c75fa172d1674f6220"
    sha256 cellar: :any, ventura:       "bd7271ed6729302479e074e72c06f2751cc6c932b038face0f7fb03d0ff13a84"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https:github.comOpenImageDenoiseoidnissues35
  depends_on macos: :high_sierra
  depends_on "tbb"

  uses_from_macos "python" => :build

  def install
    # Fix arm64 build targeting iOS
    inreplace "cmakeoidn_ispc.cmake", 'set(ISPC_TARGET_OS "--target-os=ios")', ""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <OpenImageDenoiseoidn.h>
      int main() {
        OIDNDevice device = oidnNewDevice(OIDN_DEVICE_TYPE_DEFAULT);
        oidnCommitDevice(device);
        return oidnGetDeviceError(device, 0);
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lOpenImageDenoise"
    system ".a.out"
  end
end