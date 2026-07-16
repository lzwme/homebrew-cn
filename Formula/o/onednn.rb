class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://ghfast.top/https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.12.3.tar.gz"
  sha256 "12d8551668515c64adae2b26e5ebeeefa48b1ad1035717fe8718fd702c5e066b"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a5018eeb0ff6ae4d0ec3c5a530ea2c92d1484908fc329a91d58a34bcc94b68f3"
    sha256 cellar: :any, arm64_sequoia: "3387bfa9e60b06d1f0a4ceaa3e7211f645a407e4cdc7f47aed5ceb54941f4d0f"
    sha256 cellar: :any, arm64_sonoma:  "fd49f74fa8b0e76f53ae026911639d2c995d7f1cfa160e3d69793bd3d79be5a2"
    sha256 cellar: :any, sonoma:        "7cec583502724aaab4448f3851d7f54b2101b104220852ad61c3a2910e802b3f"
    sha256 cellar: :any, arm64_linux:   "d0912439d906a79e969d6fa8c016ce51a12c371ba2efdd6d758c3117f14970af"
    sha256 cellar: :any, x86_64_linux:  "c96b1da20284057632b94499f34a2e66f77eacb66bde76d29ba0d6eb06b8a234"
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