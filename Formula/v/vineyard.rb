class Vineyard < Formula
  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https:v6d.io"
  url "https:github.comv6d-iov6dreleasesdownloadv0.24.2v6d-0.24.2.tar.gz"
  sha256 "a3acf9a9332bf5cce99712f9fd00a271b4330add302a5a8bbfd388e696a795c8"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "1e523a56e12c147bf7169720737ed422f8bc6092c295557c0e3d7daaa6799b28"
    sha256                               arm64_sonoma:  "f3d6060bf786fe16cd5f2885eee5428e45dc4655cb061a1a90873f33ba596769"
    sha256                               arm64_ventura: "bd04f41327ff13207caa720dfc459585336e4572c843d7a28babe77ffd52b78c"
    sha256                               sonoma:        "cb25f9308b95310edf63637abf5a5e26dc61fd4a4680b649ab12c645e6ee7d30"
    sha256                               ventura:       "932d86751cc8df0045186b5fa15a7b9ced9313214a294a5b002629d71de5e72a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e94664da0a8f82686aaec91f5db75543bb11d9b430c47fc63040495e1b5507db"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => :build # for clang Python bindings
  depends_on "openssl@3" => :build # indirect (not linked) but CMakeLists.txt checks for it
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => :build
  depends_on "apache-arrow"
  depends_on "boost@1.85"
  depends_on "cpprestsdk"
  depends_on "etcd"
  depends_on "etcd-cpp-apiv3"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libgrape-lite"
  depends_on "open-mpi"

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    python3 = "python3.13"
    # LLVM is keg-only.
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
    ENV.prepend_path "PYTHONPATH", llvm.opt_prefixLanguage::Python.site_packages(python3)

    args = [
      "-DBUILD_VINEYARD_PYTHON_BINDINGS=OFF",
      "-DBUILD_VINEYARD_TESTS=OFF",
      "-DCMAKE_CXX_STANDARD=17",
      "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
      "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON", # for newer protobuf
      "-DLIBGRAPELITE_INCLUDE_DIRS=#{Formula["libgrape-lite"].opt_include}",
      "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
      "-DPYTHON_EXECUTABLE=#{which(python3)}",
      "-DUSE_EXTERNAL_ETCD_LIBS=ON",
      "-DUSE_EXTERNAL_HIREDIS_LIBS=ON",
      "-DUSE_EXTERNAL_REDIS_LIBS=ON",
      "-DUSE_LIBUNWIND=OFF",
    ]
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace `open-mpi` Cellar path that breaks on `open-mpi` versionrevision bumps.
    # CMake FindMPI uses REALPATH so there isn't a clean way to handle during generation.
    openmpi = Formula["open-mpi"]
    inreplace lib"cmakevineyardvineyard-targets.cmake", openmpi.prefix.realpath, openmpi.opt_prefix
  end

  test do
    (testpath"test.cc").write <<~CPP
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
    CPP

    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)

      project(vineyard-test LANGUAGES C CXX)

      find_package(vineyard REQUIRED)

      add_executable(vineyard-test ${CMAKE_CURRENT_SOURCE_DIR}test.cc)
      target_include_directories(vineyard-test PRIVATE ${VINEYARD_INCLUDE_DIRS})
      target_link_libraries(vineyard-test PRIVATE ${VINEYARD_LIBRARIES})
    CMAKE

    # Remove Homebrew's lib directory from LDFLAGS as it is not available during
    # `shell_output`.
    ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}lib"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

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