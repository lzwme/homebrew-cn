class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://ghproxy.com/https://github.com/v6d-io/v6d/releases/download/v0.15.2/v6d-0.15.2.tar.gz"
  sha256 "08e7868cde64a3966510b627c9a37c806eb6438a6fe42f0d7816e6ccf868599f"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "f3ae32fed8a7ee8f849d7ab09c735dc5e23cae2d5563d0157172de11703278ed"
    sha256                               arm64_monterey: "69261bcbb543a5768213003c0bfbe3835a9557ffd30d62a92cc9af8effbc153f"
    sha256                               arm64_big_sur:  "c0bc3a3b135e4cbe60d4a901f1f59e8df955bc2c5b162362e0991a3402077f90"
    sha256                               ventura:        "527277f17405722c9b2d271d7c7f125955caa5799bcbe6fc3bfa2f03eccd6062"
    sha256                               monterey:       "40d54121a2c7bc54f1f3797e9a53a40cee4b8cf88826c0494a2aaefe90581e6c"
    sha256                               big_sur:        "8932c267d15405a297d6056349c2520d6034d13ae8d3c22893a785c2545f92da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b290fe827c2f0d3bdf8e2b852cde8d21e0842464a02ddf65f5a9c3e0364fc3c"
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
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "libgrape-lite"
  depends_on "open-mpi"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "redis"

  fails_with gcc: "5"

  # Fix build on macOS. Remove in the next release
  patch do
    url "https://github.com/v6d-io/v6d/commit/6b6f46c5c288c0bd6b65166afb13a66b3b9efb40.patch?full_index=1"
    sha256 "deea245016bf1e016bbefb5d0ce6ee7bb5427b57d6f4f0343795dba1630dde61"
  end

  def install
    python = "python3.11"
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/Language::Python.site_packages(python)

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{which(python)}",
                    "-DUSE_EXTERNAL_ETCD_LIBS=ON",
                    "-DUSE_EXTERNAL_REDIS_LIBS=ON",
                    "-DUSE_EXTERNAL_HIREDIS_LIBS=ON",
                    "-DBUILD_VINEYARD_TESTS=OFF",
                    "-DUSE_LIBUNWIND=OFF",
                    "-DLIBGRAPELITE_INCLUDE_DIRS=#{Formula["libgrape-lite"].opt_include}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
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