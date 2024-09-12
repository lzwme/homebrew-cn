class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3"
  url "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3archiverefstagsv0.15.4.tar.gz"
  sha256 "4516ecfa420826088c187efd42dad249367ca94ea6cdfc24e3030c3cf47af7b4"
  license "BSD-3-Clause"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a3e301db665d32c103a3f81bb8a8c66e9d34103c6fd9dda8d14f992ef6e8c001"
    sha256 cellar: :any,                 arm64_sonoma:   "e1bc96364d65c6369e851e5eaf0999cac7a970b0c3fb56aeaac1a1ff50b73d35"
    sha256 cellar: :any,                 arm64_ventura:  "6ecd55cddca1782a3f385a1fb61d5bda3118a28cc1822e48aa77b56a1d295cf2"
    sha256 cellar: :any,                 arm64_monterey: "40630894a19b0bc612bfb758f7ecd6a4b53a0d32f45e1e8d5df923e6ee6ac437"
    sha256 cellar: :any,                 sonoma:         "b8699fa6eed21082bda02fe24785fbdde51c9ea3396cfd917ec293bf88563b04"
    sha256 cellar: :any,                 ventura:        "4bbb79b67933a491aeaa8029c3ca576e416bfdb535aba368aa142afccf41cdae"
    sha256 cellar: :any,                 monterey:       "b4894881b6a5a49b3a7d9ea35b6af3448a3eb1be770b056a87f085027970f76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad979f8d5dcb46f2f32661731b739d00b00ecb09ceee3a08713a6a6e3d33bb9a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "etcd" => :test

  depends_on "abseil"
  depends_on "boost"
  depends_on "c-ares"
  depends_on "cpprestsdk"
  depends_on "grpc"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DBUILD_ETCD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port

    (testpath"test.cc").write <<~EOS
      #include <iostream>
      #include <etcdClient.hpp>

      int main() {
        etcd::Client etcd("http:127.0.0.1:#{port}");
        etcd.set("foo", "bar").wait();
        auto response = etcd.get("foo").get();
        std::cout << response.value().as_string() << std::endl;
      }
    EOS

    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      set(CMAKE_CXX_STANDARD 17)
      project(test LANGUAGES CXX)
      find_package(protobuf CONFIG REQUIRED)
      find_package(etcd-cpp-api CONFIG REQUIRED)
      add_executable(test_etcd_cpp_apiv3 test.cc)
      target_link_libraries(test_etcd_cpp_apiv3 PRIVATE etcd-cpp-api)
    CMAKE

    ENV.delete "CPATH"
    system "cmake", ".", "-Wno-dev", "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}lib"
    system "cmake", "--build", "."

    # prepare etcd
    etcd_pid = spawn(
      Formula["etcd"].opt_bin"etcd",
      "--force-new-cluster",
      "--data-dir=#{testpath}",
      "--listen-client-urls=http:127.0.0.1:#{port}",
      "--advertise-client-urls=http:127.0.0.1:#{port}",
    )

    # sleep to let etcd get its wits about it
    sleep 10

    assert_equal("bar\n", shell_output(".test_etcd_cpp_apiv3"))
  ensure
    # clean up the etcd process before we leave
    Process.kill("HUP", etcd_pid)
  end
end