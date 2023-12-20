class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https:v6d.io"
  url "https:github.comv6d-iov6dreleasesdownloadv0.19.1v6d-0.19.1.tar.gz"
  sha256 "8da78864003cc559825cde30aa1de41ecf5c653ccc23a699c15a5b02796e86ca"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "5ddf8bf57a1d4497b73f4570dcb5572b03ab28bfa18b6ee2e2fd782e53f65bf6"
    sha256                               arm64_ventura:  "8bdf724373cd9540d734b0b9e4e944cd928e934491926fde20bbd357f55ed059"
    sha256                               arm64_monterey: "c8c70e1f082c232701bae3331a1e8c50502135d8abd49be3ae296152e44c5ad7"
    sha256                               sonoma:         "0bf37b6833d26e382aa3bef4d5faa4a5ad64f362ca54f7b875d3fdaaf77d6ab9"
    sha256                               ventura:        "0d8e6e76995bf80823b9de6bd7ae99de77385fc6501db65957f553e056d9acca"
    sha256                               monterey:       "c891db7625e7d5f8acc663c6c87774b7ff2ded0c68fdd6133663c04eb16b175f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e0384dba1e9ae2bdb2d45804738362b047c2529bbbc93efba707ac9987d8b50"
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

  # upstream issue report, https:github.comv6d-iov6dissues1652
  patch :DATA

  def install
    python = "python3.12"
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefixLanguage::Python.site_packages(python)

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
    (testpath"test.cc").write <<~EOS
      #include <iostream>
      #include <memory>

      #include <vineyardclientclient.h>

      int main(int argc, char **argv) {
        vineyard::Client client;
        VINEYARD_CHECK_OK(client.Connect(argv[1]));

        std::shared_ptr<vineyard::InstanceStatus> status;
        VINEYARD_CHECK_OK(client.InstanceStatus(status));
        std::cout << "vineyard instance is: " << status->instance_id << std::endl;

        return 0;
      }
    EOS

    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)

      project(vineyard-test LANGUAGES C CXX)

      find_package(vineyard REQUIRED)

      add_executable(vineyard-test ${CMAKE_CURRENT_SOURCE_DIR}test.cc)
      target_include_directories(vineyard-test PRIVATE ${VINEYARD_INCLUDE_DIRS})
      target_link_libraries(vineyard-test PRIVATE ${VINEYARD_LIBRARIES})
    EOS

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    # Remove Homebrew's lib directory from LDFLAGS as it is not available during
    # `shell_output`.
    ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}lib"

    # macos AppleClang doesn't support -fopenmp
    system "cmake", "-S", testpath, "-B", testpath"build",
                    "-DCMAKE_C_COMPILER=#{Formula["llvm"].bin}clang",
                    "-DCMAKE_CXX_COMPILER=#{Formula["llvm"].bin}clang++",
                    *std_cmake_args
    system "cmake", "--build", testpath"build"

    # prepare vineyardd
    vineyardd_pid = spawn bin"vineyardd", "--norpc",
                                           "--meta=local",
                                           "--socket=#{testpath}vineyard.sock"

    # sleep to let vineyardd get its wits about it
    sleep 10

    assert_equal("vineyard instance is: 0\n",
                 shell_output("#{testpath}buildvineyard-test #{testpath}vineyard.sock"))
  ensure
    # clean up the vineyardd process before we leave
    Process.kill("HUP", vineyardd_pid)
  end
end

__END__
diff --git amodulesgraphCMakeLists.txt bmodulesgraphCMakeLists.txt
index 2e9e69f..781b11c 100644
--- amodulesgraphCMakeLists.txt
+++ bmodulesgraphCMakeLists.txt
@@ -63,8 +63,10 @@ file(GLOB_RECURSE GRAPH_SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}" "fragment*.cc"

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