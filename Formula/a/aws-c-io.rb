class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https:github.comawslabsaws-c-io"
  url "https:github.comawslabsaws-c-ioarchiverefstagsv0.15.5.tar.gz"
  sha256 "0ebf91f9d0be8b4d342fa13d85be5da97de532ed75955fb518b17c111abec8ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f267e2e472ed0c799b14a0fa163eee8fbf423ff8e7aa5f33f6bfcef27ad238c3"
    sha256 cellar: :any,                 arm64_sonoma:  "4adc1606293b12ce53ed5f98a21ca3998bb46ba31a25183652acbe16fb6178eb"
    sha256 cellar: :any,                 arm64_ventura: "15de2ad7c96cd7791cb1d6262834d138b7f5926047661d45c5152a436530c6d4"
    sha256 cellar: :any,                 sonoma:        "68365b5235235bc1b8632e2742166e709977d05256b162745b442e0d9b6e67b9"
    sha256 cellar: :any,                 ventura:       "fdf1624dbb32e85d984fb62cec99532192bdcd9818aa0ae5fd88a27a99b66687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb1db2c1735741e10fdcf0a27044e95ea54d619d44ea19c656504520af2776c"
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