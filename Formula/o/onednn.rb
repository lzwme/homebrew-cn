class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://ghfast.top/https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.9.2.tar.gz"
  sha256 "2a4495e7070a8fcb4366b5a82ff1ca098d8526a6f127ae864aa1ca4bebeae125"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9164bd6780e1067db0f57fea3ddee29f01a9223986729babd967e228304a93b"
    sha256 cellar: :any,                 arm64_sequoia: "616cb57e2af4c821ff076bbdb1e6115a69d4fc594b4c3671410e89bedbf399f8"
    sha256 cellar: :any,                 arm64_sonoma:  "66975767943e306ec929667420eb7ed7ed958388cd2dbd4f2ea08c1e1b0516ca"
    sha256 cellar: :any,                 sonoma:        "39cf691fe025ba1631d7469915583c3fe0c490bb76467d0e5d0debf258112ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fc24603a71ea4a613eb3bdd527eef5b298eeb9e41b262c093b3598a4ba3d4b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "258c52c3418f96f52b44b3515b61b1e18b0c39edaf221a2a53b110bffb9c1d45"
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