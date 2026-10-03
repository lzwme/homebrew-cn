class HdrhistogramC < Formula
  desc "C port of the HdrHistogram"
  homepage "https://github.com/HdrHistogram/HdrHistogram_c"
  url "https://ghfast.top/https://github.com/HdrHistogram/HdrHistogram_c/archive/refs/tags/0.12.0.tar.gz"
  sha256 "6bc54427b2e5c3639f08f13517a38deb242f8b97b44964d584834d44f02a0be1"
  license any_of: ["CC0-1.0", "BSD-2-Clause"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "532d825722f6529ffc01c4828831043da9919283f2e09dbeaca9ec19aa5f5b74"
    sha256 cellar: :any, arm64_tahoe:       "b0987ffa1bbe7545fd5fe57f7508acf723e65df13073d4683fd2fff8e736df8d"
    sha256 cellar: :any, arm64_sequoia:     "83285c4906088c1bfb67299ef198e381dfc5e7ba172641c26089110dd59475bd"
    sha256 cellar: :any, arm64_linux:       "e0cb04b42342bde10ff4fb8eda57bf38dcb04d69fff4817027c622f094579134"
    sha256 cellar: :any, x86_64_linux:      "d3b27766bf9ad7fd61ef91315e07df070ce7fc8ce3ea2cf6dca5d3cc1e5529fc"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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