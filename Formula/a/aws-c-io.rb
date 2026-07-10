class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.27.3.tar.gz"
  sha256 "3ee8a4a6d648ff423551e220f1f24c488f4839bd702cbcf6a4db1ffc606969f9"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ba775bb4fe1bd5c1f479ea83193ea529da713c0f6789bbbd98fcc44496f4088e"
    sha256 cellar: :any, arm64_sequoia: "aafcf7aec2774d20856cc660794023729f9b61477463551eb0dea6ddf964618c"
    sha256 cellar: :any, arm64_sonoma:  "d9a82faa5d9dc9315204479d56c7e7d15090ba1385c38b2d61f1d3c401189df5"
    sha256 cellar: :any, sonoma:        "19c970ca621a52cd46030044cce25276c5df6e2ee5d152ad347777a7a4a8d398"
    sha256 cellar: :any, arm64_linux:   "83c36c96bc9f09ca0487adb0f9df1165cae4cf4b6103dce4574432454e558b89"
    sha256 cellar: :any, x86_64_linux:  "e708c172b7552495a0516974aba9b2b2ad5c285cea7f208924647d8940b34efa"
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