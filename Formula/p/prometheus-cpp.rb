class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https:github.comjupp0rprometheus-cpp"
  url "https:github.comjupp0rprometheus-cpp.git",
      tag:      "v1.2.1",
      revision: "f25f74b71cc3347bcbd80008478676fa2b1b9a70"
  license "MIT"
  head "https:github.comjupp0rprometheus-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d15cfda2ab2021a48349562cf80c38791cf0f00bbe3307c5f9fb0376777e6743"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f30fd0dfcdce66b3e16a96aca355a2cfccdf163e2d5bd86a8163092a340c8e74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f41eab01b174de60066a69737a62eeccf0032e069e6bfa73f0d7a3ecd171f49"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ba47b1dd934c0733998c98243674a9f181e8b71f78e6a84436e85faadc926bc"
    sha256 cellar: :any_skip_relocation, ventura:        "8472d971fe145ab80badbaa82d3f779583893c4ecc956efaa224e96eb5eaf719"
    sha256 cellar: :any_skip_relocation, monterey:       "07c4a71fbd219a5b0f2a4b8b977936a1ed0a3189591ddd8476ef1daf6f456549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f90b8cf08ccc68ae1786d31cc815dcac867f15fa87b24c4cd9f865413cf4f7"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <prometheusregistry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system ".test"
  end
end