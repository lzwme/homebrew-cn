class AwsCEventStream < Formula
  desc "C99 implementation of the vnd.amazon.eventstream content-type"
  homepage "https:github.comawslabsaws-c-event-stream"
  url "https:github.comawslabsaws-c-event-streamarchiverefstagsv0.5.2.tar.gz"
  sha256 "df56bcaab671e4aa898725e35e5d60becf5410bc652be9f9025ab414ba3ab7db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d5031f9be3e33e04dccd3853a8e9e83deb78043597571b29ca3ad8f3d39299a"
    sha256 cellar: :any,                 arm64_sonoma:  "cb2bc5592c46f2f78f89a2c923430141d29d318308e79921b0b6e0885aecdd5d"
    sha256 cellar: :any,                 arm64_ventura: "21b7c06a561252cf2e4372372563eb1b1b223988bd86653de19eff6d36a8936b"
    sha256 cellar: :any,                 sonoma:        "977395532265203256a30031f2feb90488f117d230337ed8b564c6ad762d9638"
    sha256 cellar: :any,                 ventura:       "4d61465d06018e895fa018d9e494e48b506c1211f9a987c7f9a691c6f85953bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59829d48ff55ea56f59115bdf58543b641a8d43fe898a02d0a4971c8696a5a9a"
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