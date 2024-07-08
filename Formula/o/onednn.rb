class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https:www.oneapi.ioopen-source"
  url "https:github.comoneapi-srconeDNNarchiverefstagsv3.5.tar.gz"
  sha256 "8356aa9befde4d4ff93f1b016ac4310730b2de0cc0b8c6c7ce306690bc0d7b43"
  license "Apache-2.0"
  head "https:github.comoneapi-srconednn.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03345f3e566b773847e8e3eda55e64cd63c1102bb6924b595b16e818e51bbba2"
    sha256 cellar: :any,                 arm64_ventura:  "6b684b56be8cec3f159e03a10f04d4e401012d35fe84aba4bc2c5b33c9a982b2"
    sha256 cellar: :any,                 arm64_monterey: "98ae4e990b8af31b52dcb808a6947975bf6d2986f36e1b0516899914abbafbed"
    sha256 cellar: :any,                 sonoma:         "00e54e01e929e9942685dea68f47d39cb08c7a3d25e6999806935eeedf7a641b"
    sha256 cellar: :any,                 ventura:        "435f54c342d43ac7262044bb5ef7ebc88964677e8355975082d1cc883ec4f4da"
    sha256 cellar: :any,                 monterey:       "8411c609fd65d4895ff6cf465c32cc82d3867f3e1624066fe903de8734603970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "552a319ecc928261437a09ecdf6cc280472ef730fc8cf7bff49f444b9fc7c260"
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