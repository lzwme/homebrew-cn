class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "8e7c22673939f733fed21e9ed6e90a6512d869adb2bbbd5c05173ce332e006e0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bfe9ae812698ddae32597c1f12244f7b4ba6b243eeadb6469fe3a3646f80e2db"
    sha256 cellar: :any,                 arm64_sequoia: "d11f915d78b47a5cc0e355753e98590cccc60b276b61823f10e4ef0eb546dd0e"
    sha256 cellar: :any,                 arm64_sonoma:  "2f198eedd56cf297b1309211e6db3b6554c6c6c08f8a76ec236309b2338ff205"
    sha256 cellar: :any,                 sonoma:        "a1a9aa450820e63711902d9b6a310e52a1dc57138a633de968e0e7e68128f75d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4036e67de5baf31acffce7151d1800e2057f8480abe4b98a53c7be68b2402c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd168e47f614acb6244d479bc7709e615afa9783b648920e8f6a842fa9ddba1"
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
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end