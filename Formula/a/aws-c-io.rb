class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "75ada840ed7ef1b8e6908a9d2d017375f9093b9db04c51caf68f8edcfd20cc4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "51f17557dec48f832e1aa582d9f70834a99f585debf34e92f8a38ea063fd256e"
    sha256 cellar: :any,                 arm64_sonoma:  "cf3edab099f8ec83eca29c065d2f7f7aaefa4bf2737bd2a323e675431ed75792"
    sha256 cellar: :any,                 arm64_ventura: "e05e3d0ac69c75f9cac6f1faec11cd80dac860959927f74202bf1ee5503f43d0"
    sha256 cellar: :any,                 sonoma:        "d944a48ca0fb35e80eb02fc815e82e1d9a83eda717b7f263299703f1c1f95506"
    sha256 cellar: :any,                 ventura:       "d7c23557c094d8712dfcb46961b8c2f45f388614a750dcb30e375b95e03e91c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d77ea1b95fd6ff223d79022eae784384e52f3514580d865c8d8315d312b4195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73eecb07c0cf234d7a9c024821f6c8901878484c3e50c8f73fcc241bb0d36ee"
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