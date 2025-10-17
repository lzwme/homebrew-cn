class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "3a335b812411c30bcc64072f148ddf6cd632d8261799cd04e54051b44506feb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccb5f8b48cbf34606adee382d31e8553af2cb7f3970b8e773fd00c6254940557"
    sha256 cellar: :any,                 arm64_sequoia: "901c65583dbc89bf5f400b0bbd27560dce91126f27902af9bdf348bd143f04af"
    sha256 cellar: :any,                 arm64_sonoma:  "9f304550194bc55d7711fb1fb61c80a6c1aa3614f6b04b6973ca55879dd176c3"
    sha256 cellar: :any,                 sonoma:        "aededdcf304c00db657aff0a8b883ac654f810a9c1412f0dd8d3c0a9c6826a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f620ca12eee9fee6a3d3d0f7edfb5a4243e578814ffdd2e881c9dea44d3fef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "995e00b022652f4ceba7077040bffb77cfea5e242d427ea2095d11f8d57cb232"
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