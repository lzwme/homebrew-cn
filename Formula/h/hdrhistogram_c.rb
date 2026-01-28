class HdrhistogramC < Formula
  desc "C port of the HdrHistogram"
  homepage "https://github.com/HdrHistogram/HdrHistogram_c"
  url "https://ghfast.top/https://github.com/HdrHistogram/HdrHistogram_c/archive/refs/tags/0.11.9.tar.gz"
  sha256 "0eb5fdb9f1f8c4b9c6eb319502f8d9e28991afffb8418672a61741993855650e"
  license any_of: ["CC0-1.0", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7ddf6ab3293d244ec56b54c22b2bcceab29a4e0af233b754e6ad443ece3b40a"
    sha256 cellar: :any,                 arm64_sequoia: "8dc24b714f1bf7fd3fcc551be90d150046ca3a8a498606b72e257b7d55838d07"
    sha256 cellar: :any,                 arm64_sonoma:  "6d76ceec4e5677b28270fe45b2b36161d4fad87f95b2c803b998fbb2be4bada7"
    sha256 cellar: :any,                 sonoma:        "bd5c101eca263aed10648169b5d6dfb3bd14a4767752e99a2a14e44f901688ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e7cd5528740d26d187668cac84d0184780bbbaa40d17ae472e47b9d94ff2602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e6c9941b0e46340858286a635edb47af4b1334d64160e5e6bb7ffb9cff6c0e6"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DHDR_HISTOGRAM_BUILD_PROGRAMS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <hdr/hdr_histogram.h>

      int main(void) {
        struct hdr_histogram* histogram;
        hdr_init(1, INT64_C(3600000000), 3, &histogram);
        hdr_record_value(histogram, 2);
        hdr_record_values(histogram, 4, 10);
        return hdr_percentiles_print(histogram, stdout, 5, 1.0, CLASSIC);
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lhdr_histogram"
    assert_equal <<~EOS, shell_output("./test")
             Value   Percentile   TotalCount 1/(1-Percentile)

             2.000     0.000000            1         1.00
             4.000     0.100000           11         1.11
             4.000     1.000000           11          inf
      #[Mean    =        3.818, StdDeviation   =        0.575]
      #[Max     =        4.000, Total count    =           11]
      #[Buckets =           22, SubBuckets     =         2048]
    EOS
  end
end