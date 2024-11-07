class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https:www.oneapi.ioopen-source"
  url "https:github.comoneapi-srconeDNNarchiverefstagsv3.6.1.tar.gz"
  sha256 "a370e7f25dbf05c9c151878c53556f27d0cbe7a4f909747db6e4b2d245f533cb"
  license "Apache-2.0"
  head "https:github.comoneapi-srconednn.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d71f88776981176f6634276f99369fd30ff814edcc858aa06a4be6fe2221ebf7"
    sha256 cellar: :any,                 arm64_sonoma:  "ba9cce091b4f962fef833e56bfd1a42a6e74120e7aafbb5e85abadaf84224551"
    sha256 cellar: :any,                 arm64_ventura: "22bd1bb22e9cede78d35d8a0a9e0131253b86904c6b4028791b6168815f1f96c"
    sha256 cellar: :any,                 sonoma:        "d39e8769e0a1238a0c6a4aba7d8e9c8f34661edcfbc299877f41896355803955"
    sha256 cellar: :any,                 ventura:       "24e279a47b585fcede217f15a7dfca2d6211c9066ad8d5eaa016317954b910c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7be5e465fa54c9024aab70640b1faf612f716c34cf098c4075fab9790b392be"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc"
    system "make", "install"
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