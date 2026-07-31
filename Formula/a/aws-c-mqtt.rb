class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "48fd84e6ff51fdce5cdc4250593d7b0f10db91f8592737c0fe69e0177ee48144"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0296d404ae066aae8d830dacb806deea73afa2ef05b079f9bb3da47fae14baf4"
    sha256 cellar: :any, arm64_sequoia: "1fdb3bf4ce80a0901a1355ee9d20caeffb62ebc84201a1c39dc90bdaba976449"
    sha256 cellar: :any, arm64_sonoma:  "ee87fb7f9e2319a6f182658f076d1afe4aa16ddd5181a7b922481c80fc477f55"
    sha256 cellar: :any, sonoma:        "ae2df057b4f0904a4239ddfb4766811fa660b10fcd8df56087e0130a2cb3d20c"
    sha256 cellar: :any, arm64_linux:   "02c353208609357f8d007b4882ed280f75fb2d582bfbedf67b44b9c3ab213809"
    sha256 cellar: :any, x86_64_linux:  "be3b3bd9df28b4434fcb8a55738602c7e6eea8623f46ccbf58bfb60d0ea00e9d"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"

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