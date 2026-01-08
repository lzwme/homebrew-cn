class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "94706c99418a5c8f10396e737fe7ca96302dfcc962b627da58d77de66a54fa04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd730d56c363c93e932519d44d11dadb5cb4109505a23a083badd18b51b84f34"
    sha256 cellar: :any,                 arm64_sequoia: "88f4478b03e5f8863af8b0a557ba2312a0135366edafbe6cbbf762aaefd5a78c"
    sha256 cellar: :any,                 arm64_sonoma:  "e5968e6d554a7ecb92f678c991121b31a1fb57a56c957836600949658d1765a3"
    sha256 cellar: :any,                 sonoma:        "3c4d1945d39c1bacdec2d521cabf558bac8dd2694eb44504fe72978ae436a092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b291fb25ce205b43d2d45b4859ccc94ac9d01b1c4208f1829a309dc74de75b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0042207a55a1bff9b76ec1bbdb2fab0a5823481d533dd6b3f55b45dca4303fc"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"

  on_linux do
    depends_on "s2n"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/io/io.h>
      #include <aws/io/retry_strategy.h>
      #include <aws/common/allocator.h>
      #include <aws/common/error.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_io_library_init(allocator);

        struct aws_retry_strategy *retry_strategy = aws_retry_strategy_new_no_retry(allocator, NULL);
        assert(NULL != retry_strategy);

        int rv = aws_retry_strategy_acquire_retry_token(retry_strategy, NULL, NULL, NULL, 0);
        assert(rv == AWS_OP_ERR);
        assert(aws_last_error() == AWS_IO_RETRY_PERMISSION_DENIED);

        aws_retry_strategy_release(retry_strategy);
        aws_io_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-io",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end