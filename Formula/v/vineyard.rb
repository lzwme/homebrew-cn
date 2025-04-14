class Vineyard < Formula
  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https:v6d.io"
  url "https:github.comv6d-iov6dreleasesdownloadv0.24.2v6d-0.24.2.tar.gz"
  sha256 "a3acf9a9332bf5cce99712f9fd00a271b4330add302a5a8bbfd388e696a795c8"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256                               arm64_sequoia: "e5fefb6b4cf166c97d1fbe080cc238b2eb3ca965be76f6da9f89ffcb68e09239"
    sha256                               arm64_sonoma:  "c89b4be50ae6ebeaa028a1747ad0b41dd89a9dabf6e1aa818f720099ddcc895b"
    sha256                               arm64_ventura: "d5b9f9c75e05e2ad226205c8039ebb59bc422820be50f4af1b4bd9c4158b5a3e"
    sha256                               sonoma:        "4dbc7c6a1185063c18dafe402cc953e97f465c3ca4d71c765122583fe9d961eb"
    sha256                               ventura:       "34d272fa2442ea030f0063a9b196986190f3d6a7e4ed83621fbd09faa044c138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fdb9b27a792dcf2a0ba98dd1c02f20e1a48f897167c7758d0ee09a38da8093c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "872e8fa3f8756f576120bf817cc87bf4999fb788dc38626d99171ee97db99ad4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => :build # for clang Python bindings
  depends_on "openssl@3" => :build # indirect (not linked) but CMakeLists.txt checks for it
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => :build
  depends_on "apache-arrow"
  depends_on "boost"
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
    # Workaround to support Boost 1.87.0+ until upstream fix for https:github.comv6d-iov6dissues2041
    boost_asio_post_files = %w[
      srcserverasyncsocket_server.cc
      srcserverservervineyard_server.cc
      srcserverservicesetcd_meta_service.cc
      srcserverserviceslocal_meta_service.cc
      srcserverserviceslocal_meta_service.h
      srcserverservicesmeta_service.cc
    ]
    inreplace boost_asio_post_files, ^(\s*)(\S+)\.post\(, "\\1boost::asio::post(\\2,"
    inreplace "srcserverservicesetcd_meta_service.cc", "backoff_timer_->cancel(ec);", "backoff_timer_->cancel();"

    # Workaround to support Boost 1.88.0+
    # TODO: Try upstreaming fix along with above
    boost_process_files = %w[
      srcserverutiletcd_launcher.cc
      srcserverutiletcd_member.cc
      srcserverutilkubectl.cc
      srcserverutilproc.cc
      srcserverutilproc.h
      srcserverutilredis_launcher.h
    ]
    inreplace boost_process_files, '#include "boostprocess.hpp"', ""
    inreplace "srcserverutiletcd_launcher.h", '#include "boostprocesschild.hpp"', ""
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.append "CXXFLAGS", "-DBOOST_PROCESS_VERSION=1"
    headers = %w[args async child env environment io search_path]
    headers.each { |header| ENV.append "CXXFLAGS", "-include boostprocessv1#{header}.hpp" }

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
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
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