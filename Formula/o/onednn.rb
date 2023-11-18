class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://ghproxy.com/https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "e0b7a9452162e854cf08b4e90bcd1b382b9903ace6a61503a872573880d24c3f"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "225753282755dcf2f7146df35e445c50d288759e502f15b3bb5e44f258d99caf"
    sha256 cellar: :any,                 arm64_ventura:  "7a9edc6083de5bf577f73b90ff740bfa92398c54301cd3db3144eb747db86294"
    sha256 cellar: :any,                 arm64_monterey: "f18c17fd57fb3c5912cbb41000514981942bab926b436cf77abacb5624d26fcf"
    sha256 cellar: :any,                 sonoma:         "c9e1dd2f7ca092d6efe6933b1bc5d5c9c16fe6cb2b5b7efa25a3a4dc0084da7b"
    sha256 cellar: :any,                 ventura:        "94651ff74e10eaad1c86134bc232d189f6f870b4092258eba155dc64c341fb69"
    sha256 cellar: :any,                 monterey:       "6ab2609744a50b44655d2d4b38ffbd651e48d3fa5efefc348cd03b85858fcaac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad2e622b3e2052a071a0f005d04d460214782140ce93461af731171f51a2805e"
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
    (testpath/"test.c").write <<~EOS
      #include <oneapi/dnnl/dnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system "./test"
  end
end