class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https:github.comawslabsaws-c-cal"
  url "https:github.comawslabsaws-c-calarchiverefstagsv0.8.3.tar.gz"
  sha256 "413a5226a881eb2d7c7b453707c90b6ad1c0f63edfc15e87087f56d7d10c2a1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d82d9cc628f442122b0facfdc92a37d6b6d3e595445fa26f6349180a4028d84c"
    sha256 cellar: :any,                 arm64_sonoma:  "aa8b87156c588140f49ca949a345143851fa0285f469c1ded420198690a2aa8a"
    sha256 cellar: :any,                 arm64_ventura: "f661003ba587deef5a76ed1afc65d56670fbfc411c25be29f601df26cc59eeb4"
    sha256 cellar: :any,                 sonoma:        "06a6d3facd739079d382fd2a47d01bc9117d44331d12bac1d9a1c73d2ab5e517"
    sha256 cellar: :any,                 ventura:       "79a818142a255630e71b73833b388cd75d475d405534b7294a502a97123c90fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ee51f7c35e2d96214119562fb07eaaa604e1fc1ce38620cf4442ee5417d3207"
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