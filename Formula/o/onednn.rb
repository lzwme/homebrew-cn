class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://ghfast.top/https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.9.tar.gz"
  sha256 "806ec963b8a89cc7555c43afbb6f5369dc9010c8cf435b85aaf708acd1a2d837"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c279c3ec4e3763e00f249143330a3ba97f96ba728829a6f206d2ff2a0e4975e"
    sha256 cellar: :any,                 arm64_sonoma:  "fbb3ee6a0d6fb0c2fe79bcd79651175bfe7c7636d804dcfe86be055b59d3a95e"
    sha256 cellar: :any,                 arm64_ventura: "939a5abbe9e3f3fd731d572b8d87403b3f4fdc4a53ba74f7f670a608a3a4578e"
    sha256 cellar: :any,                 sonoma:        "e368e43870532ef4b9888b15460423da6561e0f14b90480fb08d249a53f86dea"
    sha256 cellar: :any,                 ventura:       "e54cc603b01a29c610e410086969adb84b43941e168493932c104ed7ed25cd1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ada273fc1287cce826890450a8f8cef8d14aa055161df6b287fa7d6facd75654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbab775c3beada472908d0a69582d5d475942936ba44605ef383b59268e585bc"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

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