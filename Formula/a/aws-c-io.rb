class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "1d4c6ac5d65acdad8c07f7b0bdd417fd52ab99d29d6d79788618eba317679cf1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d60e2c533a0a7c2885acde5cc0537b3c557afa39d05d5ff690a716560a71efc1"
    sha256 cellar: :any,                 arm64_sonoma:  "1afc4a2dd1d31eeead59fa3ce4b9220483c7e16c5cfbb0ca92fa92b437f18979"
    sha256 cellar: :any,                 arm64_ventura: "2c1bf7d353cbb8e4efcc2b4a606d6d03ed5bbb968db107989b054d790accc05c"
    sha256 cellar: :any,                 sonoma:        "3e2a8dd18dcb9b8424e731ec9f5667ecb3512f5f2d4a1df64d48cc1669b4a70d"
    sha256 cellar: :any,                 ventura:       "0416e3977c1e0f6a4d5070a5709b929e6962880e3523351c1e7651218edf381a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4961ca4801c8f13ed6eed68f0d96ccdb74385a381654d3bbd084366e0ce3690c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62cc0ec333f49c9d24bf3601cf206ed2a0a25f33049f1fbc6e16d7ba2126c38e"
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