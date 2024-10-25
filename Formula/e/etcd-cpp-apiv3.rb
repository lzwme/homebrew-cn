class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3"
  url "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3archiverefstagsv0.15.4.tar.gz"
  sha256 "4516ecfa420826088c187efd42dad249367ca94ea6cdfc24e3030c3cf47af7b4"
  license "BSD-3-Clause"
  revision 16

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b76b96cd7d80e7cb2e0ba90b92d60a1bf89d796d29605a871d96c8f8c06b346"
    sha256 cellar: :any,                 arm64_sonoma:  "1078d19094b4bed5bd5240e17cb44135a734b83af555b3715a491736efb6ebe1"
    sha256 cellar: :any,                 arm64_ventura: "4910990971259b62ec78f64ee52157abdda1fdd7194adda3e0f899b5ae91037c"
    sha256 cellar: :any,                 sonoma:        "1323673be616c96ec491f3a5783c1c7b4d46c185d12f1a6ca2bf864b97a30a74"
    sha256 cellar: :any,                 ventura:       "55c2b4ca0e633f6bbb72449dc273642f5c76524f4bea669304e6e6921da77209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85820d60681bb9666dbe24ef55af6c0759cb0ef12eb71df3e2e6a6a9545fb25f"
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