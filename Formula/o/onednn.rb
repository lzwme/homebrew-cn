class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https:www.oneapi.ioopen-source"
  url "https:github.comoneapi-srconeDNNarchiverefstagsv3.8.tar.gz"
  sha256 "06c11b9e4d25ddaaec219f0e93f6bdbbbc27dcf8eb992f76b768a2a056a087a9"
  license "Apache-2.0"
  head "https:github.comoneapi-srconednn.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e42d753c017a4e5500215f1da35107ac56151e25a9ea7666938c8a725114c73d"
    sha256 cellar: :any,                 arm64_sonoma:  "1e3f1a23fad88728134a6ac98434186de4a4636ed53b823ca215b5971e7882d6"
    sha256 cellar: :any,                 arm64_ventura: "7eb34b92c93de40314a520bbeef8864e32f6a69f8a88d38a7d54968cf9db44fd"
    sha256 cellar: :any,                 sonoma:        "fbd866baa63a125581698f932aa553624b2a83c709a208da762882017d0615e8"
    sha256 cellar: :any,                 ventura:       "253634f300fd2d1a6271892b82db065b67da14a8fa68784f654852fb208f2e06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95dd950079e37cacfd9b163a17c6b69d33723bb453a862bf2513166d9cdc0501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291943a184e27b72f6701a76a9a13bd3178b0aaee19ee8cbda4daabdf76c465f"
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