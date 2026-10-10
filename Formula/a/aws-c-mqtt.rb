class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "b0423915888c33b065bb3dee5569e8a70abe06c8e2345df8a736c3b18805b294"
  license "Apache-2.0"
  compatibility_version 4

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "151b169d45183e3f5af57eae8c214acd8f2a1d87f447fea18dc21b179a8e393f"
    sha256 cellar: :any, arm64_tahoe:       "e81211e1a3061bbc72b68ce5a23a2bed3f4d2f31ee4dc218c0e784de58b0fbc1"
    sha256 cellar: :any, arm64_sequoia:     "a227009eff4a9611443c2ddd787861ad4dd81ec5aeacba43c3e2396067918eb1"
    sha256 cellar: :any, arm64_linux:       "3b5dbce47017e608d011b77978fb6d3f735bc680ad630cb263e1fddc8694a211"
    sha256 cellar: :any, x86_64_linux:      "8e51e4e9d97c8184b83b5e349c723ea5e1cbfa9fb90e1dd2b5599df93d6e65e8"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"

  deny_network_access!

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to `aws-c-cal` and `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/allocator.h>
      #include <aws/mqtt/mqtt.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_mqtt_library_init(allocator);
        aws_mqtt_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-mqtt",
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end