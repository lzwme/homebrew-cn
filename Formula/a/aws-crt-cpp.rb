class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.43.4.tar.gz"
  sha256 "59e508878c5809b446bbe035ac71ea42c6e3b12978bcc2705a01490d1ba62577"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e775f1163f26ebfc973f66320b84a71d0cf2aaa31af8a5a3378f7a0e0d46ed6a"
    sha256 cellar: :any, arm64_sequoia: "8a4e51deca36a3f53b6eec9f2bb88acde0bcf5515e79e9b0deb6af3b6cd7b704"
    sha256 cellar: :any, arm64_sonoma:  "b5dbf140573d00332db605014ea41785d3f29960d16de2cd499e844ef834c54a"
    sha256 cellar: :any, sonoma:        "a141e88ce0f55002a676be4fcdd6af56dcb97ea8e99df97ff6f991c2eb492a89"
    sha256 cellar: :any, arm64_linux:   "0fd3bde7ebdc9eb7c951357616dfbb510a72a882fe1030a6ae004d83026e546a"
    sha256 cellar: :any, x86_64_linux:  "7e8c3e8733b7211a0f59ef10644e8651a709bd1e495e85eee9350221b960aae9"
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
      -DCMAKE_MODULE_PATH=#{formula_opt_lib("aws-c-common")}/cmake
    ]
    # Avoid linkage to `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <aws/crt/Allocator.h>
      #include <aws/crt/Api.h>
      #include <aws/crt/Types.h>
      #include <aws/crt/checksum/CRC.h>

      int main() {
        Aws::Crt::ApiHandle apiHandle(Aws::Crt::DefaultAllocatorImplementation());
        uint8_t data[32] = {0};
        Aws::Crt::ByteCursor dataCur = Aws::Crt::ByteCursorFromArray(data, sizeof(data));
        assert(0x190A55AD == Aws::Crt::Checksum::ComputeCRC32(dataCur));
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-laws-crt-cpp"
    system "./test"
  end
end