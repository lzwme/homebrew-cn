class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://ghfast.top/https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.14.tar.gz"
  sha256 "063eca4137678ba79b2da7030cbe2b41b1cc7b15a76ac13728a531a710e7392d"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "65d00d4ea28aa0aeb4eb9739eb240d4879688e9d71dc59796cc9e5fbceaa0955"
    sha256 cellar: :any, arm64_tahoe:       "98181987dc19d801a212411c0661bb8edc72ad380f5d2b72a102b9b90c79238f"
    sha256 cellar: :any, arm64_sequoia:     "29ead0d2821c873152269f36bf450583776a2ba0561431c72dbefcc1887d3761"
    sha256 cellar: :any, arm64_linux:       "2b82d4f9b7a8f088acfc18f2d5f7791562c36aac174c2fd6e4210e0a358a1609"
    sha256 cellar: :any, x86_64_linux:      "61e0e642a99f893d7c3ed228cbc191b3d495fe1aa2657575b0d74693eb5fa0fd"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    # Keep KleidiAI's per-target `-march=...+fp16/+sve/+sme` flags; kernels are selected at runtime
    ENV.runtime_cpu_detection if Hardware::CPU.arm?

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