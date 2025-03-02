class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https:www.oneapi.ioopen-source"
  url "https:github.comoneapi-srconeDNNarchiverefstagsv3.7.1.tar.gz"
  sha256 "580f56abe12f2bd9d628a47586b00c516d410b086d7227a800aedc4891f4e93a"
  license "Apache-2.0"
  head "https:github.comoneapi-srconednn.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7aa58986cbfa157f1bcb7e6fa05689409703f88656b1c51da41fc02a9e79b77c"
    sha256 cellar: :any,                 arm64_sonoma:  "13f257d2e8da57cdd582119230505ee2734b618ea3c63d1bfbc1bdf72a0ac74e"
    sha256 cellar: :any,                 arm64_ventura: "745937e7ca40246a74eff5f8d01bc40127869c83988045482851f0d56812240e"
    sha256 cellar: :any,                 sonoma:        "e5a652849398744fb47025498c5e56567f5e1ad60517534a3c5e63bce4189ec6"
    sha256 cellar: :any,                 ventura:       "eec3ea682aba6bb23c5d66b3ecace9484993b51499385fbfa9a89984ad6f0204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d58cc8b8465bb381019650cc8b94f21c71c01f622e2743531e1a23a1a7ff0d36"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <oneapidnnldnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system ".test"
  end
end