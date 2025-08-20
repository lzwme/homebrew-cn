class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "e663c3bb18bf335b9d715ddad13c921fe14777913d3b66e0b5b045fa81050c98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f606031051661607f085235dd7cee1d31848ed700b3ec550c8e7e79b1c964408"
    sha256 cellar: :any,                 arm64_sonoma:  "0ab78109967804e89fa4f590a934590cf1269cfb5b66caf25e27fe98638cc4bb"
    sha256 cellar: :any,                 arm64_ventura: "2132fc6ccbdcedae01cbc60f155faefef15e272a932ede2f54e100de8c609bcb"
    sha256 cellar: :any,                 sonoma:        "474ef94f381e12d438c849e42f542b52025f83be5df745f00c8f9ddb8337317d"
    sha256 cellar: :any,                 ventura:       "50ba62b1644531f5815a6c61f6fbb38fb5a91d9484c529e1f5d3198ba7b84623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91e515695e7c7ace17a8a2d8fda2cba920a7f4090740b873c72bac3eb6eed2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bacf29ba7e02e5343a7fbc0e98badf453b3d938fb6308621f8d9ee55f694701c"
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