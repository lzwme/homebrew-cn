class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://ghfast.top/https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.10.tar.gz"
  sha256 "ba5834a1fdbb6d1c1b1c065dfd789438e7aa42c03fc52d92c02af85d78d1c75c"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5825396a5c39fb50453a0816a4fc3d0c5985d690767908b250fc28c7c33e0c6"
    sha256 cellar: :any,                 arm64_sequoia: "6bb473a4ae700eaa4e82ce5370b586a95bc09d2206ef92a5e01469dbb9d97f48"
    sha256 cellar: :any,                 arm64_sonoma:  "c2bb800b3c5f1a96f3fa1649366aa4fcfd13c9683b59d7417e6252c87b8d0666"
    sha256 cellar: :any,                 sonoma:        "a4098b959cd839936ce178abfbeb899a9d3e56cd7530592e1f1d0351c6cd33f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d556279c9fd53ad1d1d1e6f4c26d05c151d6b614bee4ea5b170cd1bfa026653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ea185e59110068cb2aa80347c34bf9b3b3769962967ef5a2fb2fd49f642ecf"
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