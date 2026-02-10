class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https://github.com/awslabs/aws-checksums"
  url "https://ghfast.top/https://github.com/awslabs/aws-checksums/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "eb59664a90ef8c09e595ee40daeb9d00ae32f2a75e4b93f2830df4bebdd68033"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec1cc8126b462a3eed6777c0573e77cc6b6b0fc3a933567be4e8d796d2ca538c"
    sha256 cellar: :any,                 arm64_sequoia: "12f97ddf4127b0155cc3d0833bb69bd4f1a17a5f916a79f850a3b61b55e3a57f"
    sha256 cellar: :any,                 arm64_sonoma:  "baa1a0cb2bbcfcb4d8ccc04ece02af07b6b8448d61b09d86294507e8e43a30d7"
    sha256 cellar: :any,                 sonoma:        "09711a7db0110d370ee353d64b7438b4dd073647c369d534aa1b890cb925a21a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a5f19109020be4456051179b21a1e36ac82bd1611e02bff8878e5da5896eeab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56715c1b4ecca021680131b5d82d0fed93c90d8832e922af3e4d3797936a9ad0"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    # Intel: https://github.com/awslabs/aws-checksums/commit/e03e976974d27491740c98f9132a38ee25fb27d0
    # ARM:   https://github.com/awslabs/aws-checksums/commit/d7005974347050a97b13285eb0108dd1e59cf2c4
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/checksums/crc.h>
      #include <aws/common/allocator.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        const size_t len = 3 * 1024 * 1024 * 1024ULL;
        const uint8_t *many_zeroes = aws_mem_calloc(allocator, len, sizeof(uint8_t));
        uint32_t result = aws_checksums_crc32_ex(many_zeroes, len, 0);
        aws_mem_release(allocator, (void *)many_zeroes);
        assert(0x480BBE37 == result);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-checksums",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end