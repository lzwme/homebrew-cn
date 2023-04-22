class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://ghproxy.com/https://github.com/v6d-io/v6d/releases/download/v0.14.1/v6d-0.14.1.tar.gz"
  sha256 "6ef1ef2e7bb8db880f9688418ebc7e65bf7b9cf02fdf4a8abc9fdf9b504ccab2"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "60af283cff1a0c5242ce3bd5babd1f10603d1ddf6688cdd23c1010454aefc357"
    sha256 arm64_monterey: "c9510e7cc5e3ce1bcfdb532f673a2235e146b19e5f2928518762af2b1d20170f"
    sha256 arm64_big_sur:  "b068f8e802efbc862c865e86fd1c8e4b2e12f1b93b0a3e17adf0aaeefbf64f69"
    sha256 ventura:        "6cd2ba55003d727dc76143761d3464cfc9c62403e3a0323483ae432fb84c2eec"
    sha256 monterey:       "9d425bbf565b680139e81c22841a86d2c37a03340c71da3cb8dea5ae86324291"
    sha256 big_sur:        "03f2b3d4eba99191deb3269326a8c961b41d2ea4ef5c152c21205c56f5c6c0ed"
    sha256 x86_64_linux:   "a6ec830c59cd16ac8460063ce2c97b2473acc49455533aef122a1b4e8bcdd7aa"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python@3.11" => :build
  depends_on "apache-arrow"
  depends_on "boost"
  depends_on "etcd"
  depends_on "etcd-cpp-apiv3"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libgrape-lite"
  depends_on "open-mpi"
  depends_on "openssl@1.1"

  fails_with gcc: "5"

  def install
    python = "python3.11"
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/Language::Python.site_packages(python)

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{which(python)}",
                    "-DUSE_EXTERNAL_ETCD_LIBS=ON",
                    "-DBUILD_VINEYARD_TESTS=OFF",
                    "-DUSE_LIBUNWIND=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <memory>

      #include <vineyard/client/client.h>

      int main(int argc, char **argv) {
        vineyard::Client client;
        VINEYARD_CHECK_OK(client.Connect(argv[1]));

        std::shared_ptr<vineyard::InstanceStatus> status;
        VINEYARD_CHECK_OK(client.InstanceStatus(status));
        std::cout << "vineyard instance is: " << status->instance_id << std::endl;

        return 0;
      }
    EOS

    system ENV.cxx, "test.cc", "-std=c++17",
                    "-I#{Formula["apache-arrow"].include}",
                    "-I#{Formula["boost"].include}",
                    "-I#{include}",
                    "-I#{include}/vineyard",
                    "-I#{include}/vineyard/contrib",
                    "-L#{Formula["apache-arrow"].lib}",
                    "-L#{Formula["boost"].lib}",
                    "-L#{lib}",
                    "-larrow",
                    "-lboost_thread-mt",
                    "-lboost_system-mt",
                    "-lvineyard_client",
                    "-o", "test_vineyard_client"

    # prepare vineyardd
    vineyardd_pid = spawn bin/"vineyardd", "--norpc",
                                           "--meta=local",
                                           "--socket=#{testpath}/vineyard.sock"

    # sleep to let vineyardd get its wits about it
    sleep 10

    assert_equal("vineyard instance is: 0\n", shell_output("./test_vineyard_client #{testpath}/vineyard.sock"))
  ensure
    # clean up the vineyardd process before we leave
    Process.kill("HUP", vineyardd_pid)
  end
end