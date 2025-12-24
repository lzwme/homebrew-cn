class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "6a37033fbe8d9542eda8b864df3d4f3cc6e2832796fbcd456792e86ad161fe7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f54bbd264b51c8d61a4ee8c34c8a70813a44826b6f2888a424901918f4464d3"
    sha256 cellar: :any,                 arm64_sequoia: "780d1b00dc156df03ead983223922787b1cdbac5f4f8f849ef8a8f50ef928f69"
    sha256 cellar: :any,                 arm64_sonoma:  "c0085b78cc4c4afcd0b2f73b6fcd165c17158eb485285d30b655e46a63d7f42b"
    sha256 cellar: :any,                 sonoma:        "0e13cdf3d857976d2d458b70ebd7c17412d33ac709768b3b22e09ae943605644"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daf494e756bac3b59ed3988ea5931d20a1f55eb4511db7740ad5419c9cee2ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dcc16a8cb49cd3c54d4009fd23662522dc71e9d0be0920403727affe6a709a5"
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