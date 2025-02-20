class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https:www.oneapi.ioopen-source"
  url "https:github.comoneapi-srconeDNNarchiverefstagsv3.7.tar.gz"
  sha256 "75949dfda63bf63cf4889c814f3de6a04444ec1fe8d6eccfcab256777b15e46e"
  license "Apache-2.0"
  head "https:github.comoneapi-srconednn.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1da89f77fd1ab659777e1bb0c35d3c0938ec43ee693bf0124f23c34bcb54d3c7"
    sha256 cellar: :any,                 arm64_sonoma:  "77e44c1530a0da613860c455d8415b4ae70ff3bba6edb5c0e6c5982b21565e1f"
    sha256 cellar: :any,                 arm64_ventura: "0a2b3bf14cb8988e19ef24c6531b3f9a15e0f8c85fd810cba5163590e14d20d2"
    sha256 cellar: :any,                 sonoma:        "c9c3be9a54310e998b68ae345aee3d00401feaaaca82472efa4456f6bf76eda8"
    sha256 cellar: :any,                 ventura:       "376995c68d708ccf164315f789e3d694a3066e23ea23d7b508dd63fb6f61768a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ed8e7537cd1fd348892dfef7cc0a09ecf9c3a9a132e7808549703e7530da3e6"
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