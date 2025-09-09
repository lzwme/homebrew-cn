class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.21.5.tar.gz"
  sha256 "badc48cc260e3075a6ee0b5de0df2deb831de512dbd0f1c68db1e1fae28fa6ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "39d42385044128e5ee9dc91099cf633fbcefe56f9ff048092737e6fdce82fcb8"
    sha256 cellar: :any,                 arm64_sonoma:  "5e92f3c45fa70213881e0700e99077feca48142e8a9c4d57ce732b4d4e4211b5"
    sha256 cellar: :any,                 arm64_ventura: "81e945a1e0911496b9fd21cbbdbe10f45851a91a1c3dc9eeeb0b23ebd28032ec"
    sha256 cellar: :any,                 sonoma:        "0abc469a705dfb06b1c4b5f0d06ba9246f4bba5fb09114a5c546938a9fcbbb44"
    sha256 cellar: :any,                 ventura:       "e355386a940b6dcc8082aad7a629c6911a37df4772e194766ef262c466579fd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3213d3770066c3b3b0d78fefead1993201f8c098c6426fd72effec1c4d50fba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426b2b3c5d6636cc6dd69e744fa527f6ff69c8e1b1f1be5d3eb8133fcc2873ca"
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