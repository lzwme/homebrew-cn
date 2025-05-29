class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https:github.comawslabsaws-crt-cpp"
  url "https:github.comawslabsaws-crt-cpparchiverefstagsv0.32.7.tar.gz"
  sha256 "9d8d5fd64fd26587e9c498ee2031846b83469992eae220da3c0d2cf46ef6ef6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be342b021befb62cd5a694ca686117ea85c0af471885e26466a47bf72d883422"
    sha256 cellar: :any,                 arm64_sonoma:  "74ac5f7efff46c59b31935ca03d0d7063c411b50de2b4939d530119a75221418"
    sha256 cellar: :any,                 arm64_ventura: "fc88a49554a3a72ec58bc484fd62e426114a2b15b79d6fde877961d39248d225"
    sha256 cellar: :any,                 sonoma:        "b8ce093f82071b3bcaa18337e502b7829edabd9ba151eb942b465df2e1b8e615"
    sha256 cellar: :any,                 ventura:       "ebc0f23f72a243da45664c26bc6e42856b0bbec91ee7b4bbe088fe7ee32cc1c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bca0fdb708fd6c29f21cf98aa44919a12c01cf8269e4360423193adcbe216bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ddafbc15ae3d5760f5dc85ad88d720c54809f981e648bd767efc39bb91fe443"
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