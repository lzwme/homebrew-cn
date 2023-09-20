class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://ghproxy.com/https://github.com/v6d-io/v6d/releases/download/v0.17.2/v6d-0.17.2.tar.gz"
  sha256 "6e6cc412dae1b918d20839279b7b39fd5332ebeb062ea209fc555399d6cc1859"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "3821d75dd97b0eb2beb1e5a37ae86dbf499575707148b6ba195cc34b9505238f"
    sha256                               arm64_monterey: "d5ea142f355077cafffe811d34f3f165b8fb429ff4971d36bc88c93ff5bd2c45"
    sha256                               arm64_big_sur:  "5aca11c7d13ee04a603570100c49b22a297bea3c96f399734d6c70b376738ca8"
    sha256                               ventura:        "a73e4b86e9fe8e9b9a1e8ff56b51366c98eff34ff25850c47ef18b744d066a1b"
    sha256                               monterey:       "1084e7a3d249352746b3caabc1c91ba8261c42da0b4fc7ce6867ec8ea6fc633e"
    sha256                               big_sur:        "79c2f37b5c501360512ee00da82ed598169060a6111bc0b254d6fe01651fe488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b626d9f2ed51762366f38fb5b19da04952589293640b24d3fac4bce61e71b4a8"
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