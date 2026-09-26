class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://ghfast.top/https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.13.3.tar.gz"
  sha256 "20ccad26f3de1de2a996b3f0c25d7e29200dcefe0561a53c72458fa90232c859"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "34024aadc337e79548b10884cfbbcc99248e94821d2745c4a071746b08a93e2a"
    sha256 cellar: :any, arm64_tahoe:       "acdb08500e963e5c0c6f0835fd0c574c9a2f1fad3d5ce1599c7f86c9f267cbdf"
    sha256 cellar: :any, arm64_sequoia:     "57fa9e420c886935dcdd173506a1deb587d91a9b728ce14b748769dbb150d37a"
    sha256 cellar: :any, arm64_linux:       "7c5625b14f01d9baef34fa18de8093c2759d5502e7630406b46c7b31d5b8751a"
    sha256 cellar: :any, x86_64_linux:      "336b984e17809cc5ac90665d1406859ee1f38c05f4c7c9468380a88ee51d994e"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <oneapi/dnnl/dnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system "./test"
  end
end