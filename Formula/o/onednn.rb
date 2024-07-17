class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https:www.oneapi.ioopen-source"
  url "https:github.comoneapi-srconeDNNarchiverefstagsv3.5.1.tar.gz"
  sha256 "f316368a0d8c5235d80704def93f0e8c28e08dfaa2231a3de558be0ae2b146e7"
  license "Apache-2.0"
  head "https:github.comoneapi-srconednn.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "279f27196d7c83334ff877fdcaa9c4b7d79014b85f58b51484cc4fcd2f117708"
    sha256 cellar: :any,                 arm64_ventura:  "865645d7230897dc8b1defc2f654619b4444c71dd22a56bc039d2a574b67e6f1"
    sha256 cellar: :any,                 arm64_monterey: "c4653d541e2e27f6477ed239f76a568a528987c043e8b2fb8f762f19a6cf5e0c"
    sha256 cellar: :any,                 sonoma:         "92ddd6b0e17852fd5e83ed02b86e107beedc911cfddc72636a465cf9dcd3e6fe"
    sha256 cellar: :any,                 ventura:        "e5aad29e0821e8deea98424af429d0ba622064b16bf9adeeeace20e9b1292b24"
    sha256 cellar: :any,                 monterey:       "2d2434bf5865f36c507f1cd1f94ffe4858a7fcfdcd6b8867de4c9ff13076213e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d27ce612ced95ad96bf6f5abb96bf10325368b9aba1c48ec1268de5e66e28fb"
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
    (testpath"test.c").write <<~EOS
      #include <oneapidnnldnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system ".test"
  end
end