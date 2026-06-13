class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "f5df9c050993b843d1e44b11245f27c2e085448e36e67c86a57f181c1e72faad"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c8b6f595f39543a4d534127dd482c3f859b55bbacc97eff1e5cc98047df39955"
    sha256 cellar: :any, arm64_sequoia: "163fd7ed823d6ee4828f0044e1bbbf89c8b5796282c893072af297eca357657f"
    sha256 cellar: :any, arm64_sonoma:  "1796775b81db50a81e22e6be44de67f6024fa1c5b11d0479035040c5c2e00c60"
    sha256 cellar: :any, sonoma:        "7fc7f5f79198909dd6be57c652185abfd855d7d5e4daf198fa169439145793cb"
    sha256 cellar: :any, arm64_linux:   "09ca1dee2b19ac5793e56d0f8f1d2f0d406a2df5119e6f966c2f07f2447158fb"
    sha256 cellar: :any, x86_64_linux:  "7ac757178d0200393fcab0c4bad8fb7e97c2dc993a3c0bf2eb03bd1d792c594d"
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
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end