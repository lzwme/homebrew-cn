class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https://github.com/awslabs/aws-c-event-stream"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "82029729758b411ce6c0b28bb970281d9028ac853a678836b81b3e5f62d7a4e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16dd53157e74ef1552971b50340daee53132881dd39f26be9c7623aacb992d25"
    sha256 cellar: :any,                 arm64_sequoia: "d9c286da2b3471797d8ae02aa91f4eca3baa642ea0e6a31ffd237bc447c49052"
    sha256 cellar: :any,                 arm64_sonoma:  "3b749cfe81fc14b701172d68bcca670e7028ca92366838797894bcbce81d8019"
    sha256 cellar: :any,                 sonoma:        "558f8451a7fb24ed505949f2a756e478be16fdd444f83ff3ae6a3b9341aaae83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "468ba0e7afdf441046deb42a2d602da5d31032dbbc80937e99eaeef58fc330b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26b52046fa32d8fab8930154b4402603f1e5ca594374983acdeb87de3002352a"
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