class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https:github.comawslabsaws-crt-cpp"
  url "https:github.comawslabsaws-crt-cpparchiverefstagsv0.29.10.tar.gz"
  sha256 "05e5c52f76458039f1f4145b220a79b1e28cd102244f0006b572e7830480d5af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc19cd7a158f4f876be47129f2c1b8e9aa195d8fc2fa8d32ed987a66829c6d9a"
    sha256 cellar: :any,                 arm64_sonoma:  "4da2207c66d0b34b0e1cbaf76520930b860066f1a4e4f65797df0d9f2e95aebe"
    sha256 cellar: :any,                 arm64_ventura: "012b55c385d1ccf726be1aa8647459976f5def5ab9e9893d39a49986045414e4"
    sha256 cellar: :any,                 sonoma:        "0aa28baf248c0a03c8078829d86efed8532fd1e4592a13a1d8cda4e2d39cfe5a"
    sha256 cellar: :any,                 ventura:       "93fc685942ea1cb49c02ca119896ab7be5eebc240fb117ddc6c739adc5603220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e50f68847466f66e0b5e6f417ce26d6423c539c7a47c6eb4e42b8516266ffc3"
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