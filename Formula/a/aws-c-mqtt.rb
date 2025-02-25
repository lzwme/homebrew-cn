class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https:github.comawslabsaws-c-mqtt"
  url "https:github.comawslabsaws-c-mqttarchiverefstagsv0.12.2.tar.gz"
  sha256 "5707e8ddb536bc6dfc65fb16e4db8f3b9510aa187a8c5b5d59824f8a9ead7a63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "54af6d13f69a12be9729b8c358e657cb3ae5c6f6eba54b42b68344e0a99aa91f"
    sha256 cellar: :any,                 arm64_sonoma:  "130a4d1612f44eed3313c611e49c7cbf60ebd1371ccafe77f5458b7e7bb93447"
    sha256 cellar: :any,                 arm64_ventura: "f036f8277eb5f5577df89294db4f0de994f2eaa74e95fcbdb2537f4acec9aab9"
    sha256 cellar: :any,                 sonoma:        "d1622fe95e0acfe83645f115d3831707bf28a1894b5605e171fe317cda225a86"
    sha256 cellar: :any,                 ventura:       "75b8f029ddfa9f2ace08719aa7e341b00a26deed61fec470c0a71b4b3929b5f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d956b20c6471723393c8e442abd1b74f3a5e5418fc2647ed8b35249b585a625"
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
    (testpath"test.c").write <<~C
      #include <awscommonallocator.h>
      #include <awsmqttmqtt.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_mqtt_library_init(allocator);
        aws_mqtt_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-mqtt",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system ".test"
  end
end