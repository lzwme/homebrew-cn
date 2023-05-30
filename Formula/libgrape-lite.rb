class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://ghproxy.com/https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "e6379a9494302b78d13b75cd05fe05aaa1643f00e52b6bf86018d650dda2ac53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "15692f02ef6b4f9d947d533b7190e65a0629244a3366eb865c56e2e5084695ed"
    sha256 cellar: :any, arm64_monterey: "a40e0d0d2145e1648f10e6b69cbb24d82c93169cf07a927fceec49930284f0b2"
    sha256 cellar: :any, arm64_big_sur:  "e05730024b75d1addebc6227cee24a3a20da8caf15e2da16691fe6f89e238b07"
    sha256 cellar: :any, ventura:        "6df90d62fdf1afe57f433dff9527630a9452d3dff2ebb8077f8dd7915e9beda4"
    sha256 cellar: :any, monterey:       "0ad46174d453b09a16601c9640985b93d1553d4912a225f49f34781e94aefcaa"
    sha256 cellar: :any, big_sur:        "39830ab02f0346fff66a785fa7d615aa1cb85d573e5d135bca5e809336285f21"
    sha256               x86_64_linux:   "ff81af0158ac48538b8e9bd9546bae26d32470990a67ca4c537dfe14ee041cff"
  end

  depends_on "cmake" => :build

  depends_on "glog"
  depends_on "open-mpi"

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <grape/grape.h>

      int main() {
        // init
        grape::InitMPIComm();

        {
          grape::CommSpec comm_spec;
          comm_spec.Init(MPI_COMM_WORLD);
          std::cout << "current worker id: " << comm_spec.worker_id() << std::endl;
        }

        // finalize
        grape::FinalizeMPIComm();
      }
    EOS

    system ENV.cxx, "test.cc", "-std=c++11",
                    "-I#{Formula["glog"].include}",
                    "-I#{Formula["open-mpi"].include}",
                    "-I#{include}",
                    "-L#{Formula["glog"].lib}",
                    "-L#{Formula["open-mpi"].lib}",
                    "-L#{lib}",
                    "-lgrape-lite",
                    "-lglog",
                    "-lmpi",
                    "-o", "test_libgrape_lite"

    assert_equal("current worker id: 0\n", shell_output("./test_libgrape_lite"))
  end
end