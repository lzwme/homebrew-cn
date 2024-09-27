class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3"
  url "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3archiverefstagsv0.15.4.tar.gz"
  sha256 "4516ecfa420826088c187efd42dad249367ca94ea6cdfc24e3030c3cf47af7b4"
  license "BSD-3-Clause"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "db4364829b5524b0c8185b61c817f218185ad7a62451ac11a01c37d30ed083a2"
    sha256 cellar: :any,                 arm64_sonoma:  "257407348c7633437ce42f73f954fb78496ea661ed72ee14661b09c80bb19a0b"
    sha256 cellar: :any,                 arm64_ventura: "b725a602642116027a4089c112ec6ddccc25ca286d584486accc6a5befdde676"
    sha256 cellar: :any,                 sonoma:        "135cb3152bae82dcc00a7a25ecaa14dbfb886ae822a970d1540f5013c44a5cb5"
    sha256 cellar: :any,                 ventura:       "aec9663a2f4624c76eb6c89769986ba2b554688f8166521522589c13235dde96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8525fc254709d4880181c5918e28584570f6516ef24658b1a98d5bfa2048e5a"
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