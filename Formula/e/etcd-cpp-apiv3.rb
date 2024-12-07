class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3"
  url "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3archiverefstagsv0.15.4.tar.gz"
  sha256 "4516ecfa420826088c187efd42dad249367ca94ea6cdfc24e3030c3cf47af7b4"
  license "BSD-3-Clause"
  revision 19

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70015fab22dae7d329ae91b5d0250d858b9ccf40ab72bbc2bf2da0f7c8ee7f3b"
    sha256 cellar: :any,                 arm64_sonoma:  "bd34f08f591a79b4900527c50893b53c2ce6c989c5804f8a1ae9839cdb6b981d"
    sha256 cellar: :any,                 arm64_ventura: "16a834c645392bee0a1327fe6caefe18aadb7e8d25885cfb83183de32e805ad0"
    sha256 cellar: :any,                 sonoma:        "04b5eb8991359e03507bf1ee905dfc0e45f07ac4e933f92e1b15d5b1421eae4d"
    sha256 cellar: :any,                 ventura:       "d0989833efd3464806a3fc301e87725b24e3c037b3ce9edef21e9b237d68bff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "745eb7731ea238c4f2f9b4d1be306dd12daadf5e3d6d26806ab6d0b3882f636a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "etcd" => :test

  depends_on "abseil"
  depends_on "c-ares"
  depends_on "cpprestsdk"
  depends_on "grpc"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

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

    (testpath"test.cc").write <<~CPP
      #include <iostream>
      #include <etcdClient.hpp>

      int main() {
        etcd::Client etcd("http:127.0.0.1:#{port}");
        etcd.set("foo", "bar").wait();
        auto response = etcd.get("foo").get();
        std::cout << response.value().as_string() << std::endl;
      }
    CPP

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