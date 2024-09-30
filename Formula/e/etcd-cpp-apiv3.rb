class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3"
  url "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3archiverefstagsv0.15.4.tar.gz"
  sha256 "4516ecfa420826088c187efd42dad249367ca94ea6cdfc24e3030c3cf47af7b4"
  license "BSD-3-Clause"
  revision 14

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "20f82f903c044f30052624d69290f367cb7248ae3ff900cd73c97cdde5335980"
    sha256 cellar: :any,                 arm64_sonoma:  "89a4f902089ae743c5f9184688b541eb3d3f26b07913b6005b028acef95e0a26"
    sha256 cellar: :any,                 arm64_ventura: "f33bd97d8719d53827ec7cce7db75fd73f0099da61d8c13e5ea4fbe12b834afa"
    sha256 cellar: :any,                 sonoma:        "c65b3c92fedd6054081e76acad4563f760668aeb24045234207826ce681b7d34"
    sha256 cellar: :any,                 ventura:       "25591125d3f5cc23e6758e50c85fb4561b477c02aa72cd68e28a2c841ff9e854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b576c7af75c11d05ae1eb34132d64617b16c2d41dbe43e7c70ce0a25a4be9dd"
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

  # Fix for removal of GPR_ASSERT macro in grpc.
  # https:github.cometcd-cpp-apiv3etcd-cpp-apiv3pull281
  patch do
    url "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3commitece56adf4d01658a5f0668a3618c97153665581c.patch?full_index=1"
    sha256 "f3686647436045a9a53b05f81fae02d5a5a2025d5ce78a66aca0ade85c1a99c6"
  end

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