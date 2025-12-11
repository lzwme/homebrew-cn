class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "dc36644c1e1c10d6d604a9fcf386b42f16e5e85f73ea2b4b684dfde14d522f5a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66342f46a14f9c81fd63a49fb33f29b95b96f1fb00fba89f4c084f8518b46af9"
    sha256 cellar: :any,                 arm64_sequoia: "1100c58d4653532fc0b38ab13668ccc5762bea9d29fd20d9746805a17cee209f"
    sha256 cellar: :any,                 arm64_sonoma:  "2700606da1f853fd8e74513880f8d0c1e6108ba6362ed2caca162cf502cd4ce0"
    sha256 cellar: :any,                 sonoma:        "708b92c316ac1cb821417929aebabab78e9f262aa957c827699e0a6b20799f84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b412155e74f93bed70bbab7f1d5df1d51223353ccaa7aab605ea5807c35f7ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "753d1e872ac0d4edc48bbdfdaa27746bcf0f1f3b13648e35d128ba81aad2c466"
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