class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "a68be4ce4d58ea1c7acb3ebf696692dc034107fe10ade3167e48649a317952c2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59c904a322472eae46ce3805937ac8e7254e451a30e50a34b3f8068d7ebf2f9f"
    sha256 cellar: :any,                 arm64_sequoia: "4e8abb18d7d8358a16ef340ccfbdf13bd386d638531aa21ae84dbf89458ff8ff"
    sha256 cellar: :any,                 arm64_sonoma:  "195e5a4ecd5e384b41a177d7b08e56417f24e634f4f920c7130fcbb6c928351a"
    sha256 cellar: :any,                 sonoma:        "a9d13203022301fe860e5ec53960324c69fc2b3f91fda206da2bc155a101c729"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2622a04ea04d9c794eef5c3068870a21f30ca988e831893d897e4f6a5ffbdac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71529a7dc2e393cfeb95fc210c3698d9fffa99aa991f31d805204551f7e31522"
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