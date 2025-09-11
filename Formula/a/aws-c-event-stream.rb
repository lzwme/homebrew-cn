class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "e94a8172e7d198d11bc7aa769c5334f1a8518f2b5bd4446d37d18fb5683623fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "794cf037e4f7ca1ef3d50c280ed7483f20a5ba6faffbe37e70b68fd21e9fc5b1"
    sha256 cellar: :any,                 arm64_sequoia: "b6284b9936cb2c292b706766a5c2e9f40a3650ca89bc38b163cdb51a77192b33"
    sha256 cellar: :any,                 arm64_sonoma:  "a8027e1e9fe79d9dbf53a6764b004ef7d4e0eadd9357389fa3a913d5268c03f8"
    sha256 cellar: :any,                 arm64_ventura: "561d94d70a0e0b68b30f2617a5a361944963f10ebf4407cdedca5753c74bd96a"
    sha256 cellar: :any,                 sonoma:        "27e451e41291333cc5c064a80950160443ca65472bb55c056a17b88c04a57302"
    sha256 cellar: :any,                 ventura:       "41b1e995eed8841f1d4f84715b53bf1813c563d9eb2d1b0086d67ae4873efde3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "436caa83aeaabfb992a772b25553af504370984873a593b448d46ac81ff421f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26c61ac9583c48c99dee64f08dbafb8f0212c249dccc6c1f14d0ae48073005eb"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-io"
  depends_on "aws-checksums"

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to `aws-c-cal`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/event-stream/event_stream.h>
      #include <aws/common/allocator.h>
      #include <assert.h>

      int main(void) {
        uint8_t test_data[] = {
          0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x05, 0xc2, 0x48, 0xeb, 0x7d, 0x98, 0xc8, 0xff};

        struct aws_allocator *allocator = aws_default_allocator();
        struct aws_event_stream_message message;
        struct aws_byte_buf test_buf = aws_byte_buf_from_array(test_data, sizeof(test_data));
        assert(AWS_OP_SUCCESS == aws_event_stream_message_from_buffer(&message, allocator, &test_buf));

        assert(0x00000010 == aws_event_stream_message_total_length(&message));
        assert(0x00000000 == aws_event_stream_message_headers_len(&message));
        assert(0x05c248eb == aws_event_stream_message_prelude_crc(&message));
        assert(0x7d98c8ff == aws_event_stream_message_message_crc(&message));

        aws_event_stream_message_clean_up(&message);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-event-stream",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end