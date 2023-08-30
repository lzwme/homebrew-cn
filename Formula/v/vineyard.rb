class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://ghproxy.com/https://github.com/v6d-io/v6d/releases/download/v0.16.5/v6d-0.16.5.tar.gz"
  sha256 "03245928b3c429920d750ab3e3f8ed1f3d68e58c024f32647971a35f34260714"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256                               arm64_ventura:  "2b45604d68b83c152cdc048628a349d904ce0f4af1a20ed0ffb1d17ac8ac82b4"
    sha256                               arm64_monterey: "dd0805d085cea76357f7b570d1d6a57423950cd4e74200679c5df1a8d3f45779"
    sha256                               arm64_big_sur:  "6d92fb30bbcf328ad46d3840968b5901d44c80018fdf1070cf9700e6e69a7d6a"
    sha256                               ventura:        "b90d5d9a1974b3904e0bbdf6059c9ed08a7bf7f6e6b3df6e41f85d61e74b24a5"
    sha256                               monterey:       "b2fe0dbfd6cfe2d3e9384f5a69492b1d7146c8588443412f70cd61bdfa513575"
    sha256                               big_sur:        "e7ee6fd542df9c0b0ee7957c2e76686cbb9188fb390fa328b1ca7a68dfc1585f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa342f739a390560536abe76bfb5e48739d94bd316a3d984d99e56190c0a6ab2"
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