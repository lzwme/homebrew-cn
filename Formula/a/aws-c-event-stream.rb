class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https:github.comawslabsaws-c-event-stream"
  url "https:github.comawslabsaws-c-event-streamarchiverefstagsv0.5.3.tar.gz"
  sha256 "98f66598f9af0f9ee714a441b0ce99777c76a0493c4802dd960dc24caa293400"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff0567aba4c3d4ecd7590547eb64078652fd07230b30cdf27ecf36089ea256f5"
    sha256 cellar: :any,                 arm64_sonoma:  "55a247841d9eb16db4c83047a429730547fff242d1ec6c38bb758bb1727abb9f"
    sha256 cellar: :any,                 arm64_ventura: "d9f5861deec4f78f719b906567392cbbbde3923e33585b892c7d5805ade1c7be"
    sha256 cellar: :any,                 sonoma:        "fe75094326e171a572c46313d8938400315ad515ce5e80671735477490a8fd38"
    sha256 cellar: :any,                 ventura:       "edb161c76b125fadafdb283d411f1ebf1c6f5184055909f38bffb69ad77c22a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fabd2be9904d78bf4ce4872a6d185c0b26b5251b5ab4f9bdef141219351bbf0b"
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
    (testpath"test.c").write <<~C
      #include <awsevent-streamevent_stream.h>
      #include <awscommonallocator.h>
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
    system ".test"
  end
end