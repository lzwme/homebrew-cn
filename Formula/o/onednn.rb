class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://ghproxy.com/https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "84cc5342fd77c58150f7429706dc42daa4bd9b2bd1451f465e5e4ed54a2f3534"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d91fba3d60bfbdbdecc4bbd42577c51e87ee444464ab821ea30194ce1d940e4"
    sha256 cellar: :any,                 arm64_ventura:  "d700763992edb8369b0835ba97ff358ffe58a0eb74f4cb0f547dc05d8aabbb9b"
    sha256 cellar: :any,                 arm64_monterey: "4820b84feac648d428658f05580be7eb381cd262f2d4272e237af962868ef2ca"
    sha256 cellar: :any,                 sonoma:         "4163071eb1dcf4f00efdaab1df5328103e34e6a812101a646c54575e9dba77c8"
    sha256 cellar: :any,                 ventura:        "818d4d863f4c982d5246ba010f6535c98de7f07952ad5da0a35a66796e972614"
    sha256 cellar: :any,                 monterey:       "ad5f2b473b150266dcdb387c742d762c87f828ac597b35fd78d354fa4e291950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb1e5c4dcc6a9ccfe66a9311b6e10d9d78a3a1c326b7db12771b7ae7ceb85ebf"
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