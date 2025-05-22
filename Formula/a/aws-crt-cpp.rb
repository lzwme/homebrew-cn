class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https:github.comawslabsaws-crt-cpp"
  url "https:github.comawslabsaws-crt-cpparchiverefstagsv0.32.6.tar.gz"
  sha256 "a7888f843ac335e704cff041044528fcd4803126a6b5330b6e2999772f76b139"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "efca204dc4fda613aa67c2bd49017a273c7b35bd632a46b9d52426abb115a541"
    sha256 cellar: :any,                 arm64_sonoma:  "faa5505b025a8b1724c5433d801075077301ad0a747f5f529c4162a5e78ecbab"
    sha256 cellar: :any,                 arm64_ventura: "b2170b6d0f58c2e26fe4d45ee3e3854e49101ce22352022d00471973830932f6"
    sha256 cellar: :any,                 sonoma:        "97590fa743b8078834432b633e1692a866756f78072697a7ce0b2e83b189688c"
    sha256 cellar: :any,                 ventura:       "98c7e2c63781f01e887cbaf27bed35e92d9edd302f06f6c92cb37814e52ba917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28dba9a623658a17a1a43503a70347fcb3fa43c4ee2290332dd8fa6b677978ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98934a672222eb905da43632b08004d7ec8e63150bfaa0867a13b3fa2cd91a6d"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-c-sdkutils"
  depends_on "aws-checksums"

  def install
    args = %W[
      -DBUILD_DEPS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}cmake
    ]
    # Avoid linkage to `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <awscrtAllocator.h>
      #include <awscrtApi.h>
      #include <awscrtTypes.h>
      #include <awscrtchecksumCRC.h>

      int main() {
        Aws::Crt::ApiHandle apiHandle(Aws::Crt::DefaultAllocatorImplementation());
        uint8_t data[32] = {0};
        Aws::Crt::ByteCursor dataCur = Aws::Crt::ByteCursorFromArray(data, sizeof(data));
        assert(0x190A55AD == Aws::Crt::Checksum::ComputeCRC32(dataCur));
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-laws-crt-cpp"
    system ".test"
  end
end