class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "ddc935d6ae0e7fda3b404a7c22ce20a0a1825c188d0087c9ffc817e8e7060325"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1118d9fe71b0c34b5a3729ae78db35f1a1dd6828b516ef31173a574f65f32529"
    sha256 cellar: :any,                 arm64_sonoma:  "0a234d01a1f19fbbf0a1d964f5c8313134cb7d5475eae7c329b41aef2c233ea5"
    sha256 cellar: :any,                 arm64_ventura: "ea02b5bd13d56d1ee8ec3df633aa1c27a0b13b403a8bf0ea1db3b7bdd8018fde"
    sha256 cellar: :any,                 sonoma:        "65e1b1c8f4492a10ebbde3308da5541995e33daf00dd096ddce2d1af811c8a03"
    sha256 cellar: :any,                 ventura:       "4681837d6731077292245ba23884ab83f43cc03443f551028cc4d0d5783e46a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bad2a5708913facf199cbfdf3bc9b9d52a4694390fc0e9969d4bdcd909cb0df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d518ed22c70fabdd78aba4af503116864c8cf04a6bead9cae319692570ec554"
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