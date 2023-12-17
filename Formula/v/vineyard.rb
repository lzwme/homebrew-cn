class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://ghproxy.com/https://github.com/v6d-io/v6d/releases/download/v0.19.1/v6d-0.19.1.tar.gz"
  sha256 "8da78864003cc559825cde30aa1de41ecf5c653ccc23a699c15a5b02796e86ca"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "b2c9512b1342f9318c6cec60f20816e648d45836178131d2c88bf6ae54ae8354"
    sha256                               arm64_ventura:  "a1a3c6c472dc6c41f0bd5e64a3826589f7cc66455e233fcb841552374afd3f3c"
    sha256                               arm64_monterey: "fa1485ae55426276487933f01a7b84beebe3cd6b262b2fb6598fa6ed8cf61745"
    sha256                               sonoma:         "076e6c63f4da6bc7511c3ac0de5db66da910111c820963a6df18ac29ec915bf7"
    sha256                               ventura:        "dceb8508aa147eaafbc2da2157035f889799092365ab621d35f4cb34ffbdf5d8"
    sha256                               monterey:       "bfc9892b02ded35fb3702d195b34b8aa93bcbbe8a6dd6c64a982c93cd60febd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da06566fbeb1903ee734e5b7493dd6264c931c2fd52f91040c87415a08e73f0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => [:build, :test]
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
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

  # upstream issue report, https://github.com/v6d-io/v6d/issues/1652
  patch :DATA

  def install
    python = "python3.12"
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/Language::Python.site_packages(python)

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

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

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)

      project(vineyard-test LANGUAGES C CXX)

      find_package(vineyard REQUIRED)

      add_executable(vineyard-test ${CMAKE_CURRENT_SOURCE_DIR}/test.cc)
      target_include_directories(vineyard-test PRIVATE ${VINEYARD_INCLUDE_DIRS})
      target_link_libraries(vineyard-test PRIVATE ${VINEYARD_LIBRARIES})
    EOS

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    # Remove Homebrew's lib directory from LDFLAGS as it is not available during
    # `shell_output`.
    ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    # macos AppleClang doesn't support -fopenmp
    system "cmake", "-S", testpath, "-B", testpath/"build",
                    "-DCMAKE_C_COMPILER=#{Formula["llvm"].bin}/clang",
                    "-DCMAKE_CXX_COMPILER=#{Formula["llvm"].bin}/clang++",
                    *std_cmake_args
    system "cmake", "--build", testpath/"build"

    # prepare vineyardd
    vineyardd_pid = spawn bin/"vineyardd", "--norpc",
                                           "--meta=local",
                                           "--socket=#{testpath}/vineyard.sock"

    # sleep to let vineyardd get its wits about it
    sleep 10

    assert_equal("vineyard instance is: 0\n",
                 shell_output("#{testpath}/build/vineyard-test #{testpath}/vineyard.sock"))
  ensure
    # clean up the vineyardd process before we leave
    Process.kill("HUP", vineyardd_pid)
  end
end

__END__
diff --git a/modules/graph/CMakeLists.txt b/modules/graph/CMakeLists.txt
index 2e9e69f..781b11c 100644
--- a/modules/graph/CMakeLists.txt
+++ b/modules/graph/CMakeLists.txt
@@ -63,8 +63,10 @@ file(GLOB_RECURSE GRAPH_SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}" "fragment/*.cc"

 add_library(vineyard_graph ${GRAPH_SRC_FILES} ${powturbo-target-objects})
 target_add_debuginfo(vineyard_graph)
-target_compile_options(vineyard_graph PUBLIC "-fopenmp")
-target_link_options(vineyard_graph PUBLIC "-fopenmp")
+if(NOT APPLE)
+    target_compile_options(vineyard_graph PUBLIC "-fopenmp")
+    target_link_options(vineyard_graph PUBLIC "-fopenmp")
+endif()
 target_include_directories(vineyard_graph PUBLIC ${MPI_CXX_INCLUDE_PATH})

 find_package(Boost COMPONENTS leaf)