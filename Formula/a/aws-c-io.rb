class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https:github.comawslabsaws-c-io"
  url "https:github.comawslabsaws-c-ioarchiverefstagsv0.16.0.tar.gz"
  sha256 "e6ba5cd9b58cfbc26a6ad376a25766147aae5fd7e44c8b228255814f8fae5730"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89b2306e7688b8a8ac774c84b7748cdc81b820f98b7ee40c3da0981a993ef11f"
    sha256 cellar: :any,                 arm64_sonoma:  "72df3a68a4e50d75085ddf69362059ed7556931aa1c1d8ba7ec324589d418ca7"
    sha256 cellar: :any,                 arm64_ventura: "49b7037825b92ab98aa78f7a3b062556b9123bf386bde0909c5a1b9d2532931f"
    sha256 cellar: :any,                 sonoma:        "b5b20e55c91ce0038a220b8d477fa939e4154414024489328677a84f23315e1b"
    sha256 cellar: :any,                 ventura:       "99e6aed4dbfae31116871c3cb393ac862ec967f824764eb55a64914ca03159b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef3d8a33586557390b644b5bc7f0ec08ae8cfb37a61c5506d1b6dd8139e1712b"
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
    (testpath"test.c").write <<~C
      #include <awsioio.h>
      #include <awsioretry_strategy.h>
      #include <awscommonallocator.h>
      #include <awscommonerror.h>
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
    system ".test"
  end
end