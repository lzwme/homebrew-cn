class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-io/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "5fecb19c2c0a165687cdd94723943a02ab23a0270deade5661fd935a3cd55e78"
  license "Apache-2.0"
  revision 1
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f46b7dcad3866a3f34ae47de4dab30213a2f40e82bebe02b675be8fd2cd4afc1"
    sha256 cellar: :any, arm64_tahoe:       "29951a3f0b658114cb68a5d54de96d24a8118e8c8d8d7705f191c779bbb7d50a"
    sha256 cellar: :any, arm64_sequoia:     "ae10073e01831d3d5aa291a4d55e09bffea410693caa489f40955283c82ab118"
    sha256 cellar: :any, arm64_linux:       "46756abd47decefbcb65dea64993c603cebc59417aca691055e69aae8e77b415"
    sha256 cellar: :any, x86_64_linux:      "425c69594305541fa85d3dcecddc79867e35b87401a2d81f93410340ac12fbf1"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "s2n"

  deny_network_access!

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to OpenSSL
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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