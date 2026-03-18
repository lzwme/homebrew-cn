class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "bf3491499e528a17247e440775775c3d47c85df94ea23b620f95c5baa5df7d1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "180452bcf79dcdca27b69bdefae91ae73ca295caa1c5dd365916fdc0eb5071f5"
    sha256 cellar: :any,                 arm64_sequoia: "bcef5a675de90b278a1c84561e5287c2a931f3d66905992b487b0507d7ff8b70"
    sha256 cellar: :any,                 arm64_sonoma:  "3fb4ce8aea2286715b1df65469d0e9b49d52e3e4177f1bd1789a7a06711e27d1"
    sha256 cellar: :any,                 sonoma:        "af4ed45d8d23c7bf400bd30266af3409f0d5ddcd66b174aac803c4cd0f2842e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7e94550808ac04c6fe8f018df9c813a88a6b674cb25934962a214c11c80253c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbb99f0e08b929817a6972444e7caceb68747aa481f4a27026eebaeb6d6c2312"
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