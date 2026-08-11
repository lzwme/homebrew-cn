class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.27.6.tar.gz"
  sha256 "2a6890715ccecaa0df6e9d074b186a7156b35360ded9db973064e2e00d45fcc3"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f0a437dde66f8eaf9af58dfddd57de92cc3281322b6920ba4b2f9e6b4d6daf45"
    sha256 cellar: :any, arm64_sequoia: "07c5aa7e81ca63015cdb8d9a78c34256872ad995d1008fbf3486e0ebf2fbe522"
    sha256 cellar: :any, arm64_sonoma:  "305cdec60d963f93cb2c36c5ff85a4e54116c5a87f919831f0cdba6e883c4e40"
    sha256 cellar: :any, sonoma:        "add7705422d9efbe8fe5f8bfda17981a71143786b21b89c7093fa3f13267aca3"
    sha256 cellar: :any, arm64_linux:   "203c5aee4bfd5bfd311ba8b7d4e472cc6668d59508cd998debdb37f711fadf33"
    sha256 cellar: :any, x86_64_linux:  "ce1f4d61455b93a530b03dc1cb9340adc69db406b8b427298c8c220171525a30"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "openssl@3"
  depends_on "s2n"

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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end