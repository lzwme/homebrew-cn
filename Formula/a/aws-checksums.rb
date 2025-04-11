class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https:github.comawslabsaws-checksums"
  url "https:github.comawslabsaws-checksumsarchiverefstagsv0.2.6.tar.gz"
  sha256 "e9d94f6f57bfadec7164943aecc4d7d1d8f74b95a626ba5edabfc7df66888cf4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0507172d01e3333a2c78937a4b1a7a41e4f25556c131e9be52929f6b2250843b"
    sha256 cellar: :any,                 arm64_sonoma:  "7da262daef93d72ab60c457cc8b83b9d814bc0fb990cab07bc0470d2229a7b50"
    sha256 cellar: :any,                 arm64_ventura: "46b593a2dcee796972c33f17994a543ec5a36f1d9b09d3196f51624032a2321e"
    sha256 cellar: :any,                 sonoma:        "d38db411f78d472c6d4f3e8548c8f8e4619731fbdea0989057876f4aeee67940"
    sha256 cellar: :any,                 ventura:       "d5f9a5d22a31449df435e23aa8c810801703aeca14566865ddb104b4233bf9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0ee0b9499104c59f47953f6093eac5ebe50b4be96f3cdd8ce08d6d14c463653"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <awschecksumscrc.h>
      #include <awscommonallocator.h>
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
    system ".test"
  end
end