class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https:github.comawslabsaws-c-cal"
  url "https:github.comawslabsaws-c-calarchiverefstagsv0.8.9.tar.gz"
  sha256 "4419890f1f720f57e3e028a4d548aef5e98946761243ca9ae10f75dc44243085"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cc667c5bb6c680e6d4dcc38c4d387952dad0ee1c87e288eebad441143e1348fa"
    sha256 cellar: :any,                 arm64_sonoma:  "825edf48281a964cfa84459fda731a65db32933af79d1d0fe1955d4cc6a242e9"
    sha256 cellar: :any,                 arm64_ventura: "f1a8c8e78374a7853410c4a31556cea38506991fdc3e3bbd509c76d58d4e2d2e"
    sha256 cellar: :any,                 sonoma:        "6f34f2bb5f83a522455240e304228b0e392c095b4763261342d879a24889e278"
    sha256 cellar: :any,                 ventura:       "d195a3d9cc40fde6742b378710829865d3bb5f17b5ef9c7068cb0f47d434d24f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfe21504c7bdafcaee36223ac69e43c88f3a99d89d8f8b1846e22aa1638aae0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ba2309fd95e69c0e6434016ed284715577befb806f50c65158b0e08a3a2713d"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    args << "-DUSE_OPENSSL=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <awscalcal.h>
      #include <awscalhash.h>
      #include <awscommonallocator.h>
      #include <awscommonbyte_buf.h>
      #include <awscommonerror.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_cal_library_init(allocator);

        struct aws_hash *hash = aws_sha256_new(allocator);
        assert(NULL != hash);
        struct aws_byte_cursor input = aws_byte_cursor_from_c_str("a");

        for (size_t i = 0; i < 1000000; ++i) {
          assert(AWS_OP_SUCCESS == aws_hash_update(hash, &input));
        }

        uint8_t output[AWS_SHA256_LEN] = {0};
        struct aws_byte_buf output_buf = aws_byte_buf_from_array(output, sizeof(output));
        output_buf.len = 0;
        assert(AWS_OP_SUCCESS == aws_hash_finalize(hash, &output_buf, 0));

        uint8_t expected[] = {
          0xcd, 0xc7, 0x6e, 0x5c, 0x99, 0x14, 0xfb, 0x92, 0x81, 0xa1, 0xc7, 0xe2, 0x84, 0xd7, 0x3e, 0x67,
          0xf1, 0x80, 0x9a, 0x48, 0xa4, 0x97, 0x20, 0x0e, 0x04, 0x6d, 0x39, 0xcc, 0xc7, 0x11, 0x2c, 0xd0,
        };
        struct aws_byte_cursor expected_buf = aws_byte_cursor_from_array(expected, sizeof(expected));
        assert(expected_buf.len == output_buf.len);
        for (size_t i = 0; i < expected_buf.len; ++i) {
          assert(expected_buf.ptr[i] == output_buf.buffer[i]);
        }

        aws_hash_destroy(hash);
        aws_cal_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-cal",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system ".test"
  end
end