class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https:v6d.io"
  url "https:github.comv6d-iov6dreleasesdownloadv0.22.1v6d-0.22.1.tar.gz"
  sha256 "16aea4dc63830925c2d8cd89dc36580ff80dd7610793d56ae5d0d09972cf2fcc"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "6f92524f4f5d2e5b71a68a54314e20b0f23caac1ab578a73d5ee2cd5fe942030"
    sha256                               arm64_ventura:  "1b1789c73b0e745d13a2d57a5620a348b622f4d8967f73b1dd2846c7d58d0bd1"
    sha256                               arm64_monterey: "30a0aabb3277ea75a836db664cb7929fe2a24807f239ac0632434cbf10274cec"
    sha256                               sonoma:         "94154dde18c24c431103d4db402bb260c99f15e79bb6c56fa0d6c0ee4f0ee435"
    sha256                               ventura:        "f0dd8408d2fdd0b693ee4baeb0f28562275891f61a48ad615929305846e82de2"
    sha256                               monterey:       "a597e092c45f61dfc0ad60971dcfe80223e7b4ce7913cd45608b31d66888bd10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e218fd701201885a89ee5da2d7ce4d7b08b06f8b93f6fc81399269b3a4e42bd"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => [:build, :test]
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

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesd64fb10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aedsetuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  # Backport fix for API changes in `apache-arrow` 16+.
  patch do
    url "https:github.comv6d-iov6dcommite8b8c828f54e16163c98a9b91068f3344608431a.patch?full_index=1"
    sha256 "b105216ad518dc581a9b9eb45398d7f87f63ba9728b3e3690aaef172a33ff3d2"
  end

  def install
    python = "python3.12"
    venv = virtualenv_create(libexec, python)
    venv.pip_install resources
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefixLanguage::Python.site_packages(python)

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{venv.root}binpython",
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