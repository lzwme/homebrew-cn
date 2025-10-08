class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "95dd09c53773fb094973c4df3d89ab376a7f2d490c1b45bba41734079355d891"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "037693842b5ac530828d048e8d06569eebc69a4de19f7e8956a07f2ec18bfad8"
    sha256 cellar: :any,                 arm64_sequoia: "cda8ab59a2e9894e6142b90a532563d5cc1f248df807517744737e5672777c02"
    sha256 cellar: :any,                 arm64_sonoma:  "c6ba097484d60a403967fe5806e54517a4d626e2a60754c023ac1ffc985b787f"
    sha256 cellar: :any,                 sonoma:        "ac893ff86d28a2ba764914491362a999087740f3f63f919d36e338ac6bc2363c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42301f45f04ca0d54ea647eaf431fb8553eb6924dfee452f84b03dd3d144c270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b211395ac128d62a73ab89144f081d39d74004b5b0e9e479112606ed9ba30313"
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