class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "ba9477f15c386b98281abb8ebb9927c0c46133f4262951e57a676169b395f782"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c4598bbd79d8c16c1df56b67532773b8ade507d46bdfde72702d86df61215c6"
    sha256 cellar: :any,                 arm64_sequoia: "fd1ebc0afd7f994e9e7fceec04908f112ab5b042423c8e44cba1b9d82eb58cba"
    sha256 cellar: :any,                 arm64_sonoma:  "2fae9788e31f899e471f04708fe4ac39093c7f5667a4d96b8a9f8f1c941a63bb"
    sha256 cellar: :any,                 sonoma:        "37b9e9b041b62f93fb41e58302de0711f6bd64fb2bb9f06c4224c8124661ff69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e7329e8c3ceea861fe4fb4bb043a623e5757512f3cabd2b1016afd51c5bdcb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eda0ea540325fe2b16b01d699c4d6ae12266f93fc100570b93f786071eb6cd2"
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