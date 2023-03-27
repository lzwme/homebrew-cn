class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://ghproxy.com/https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "2cd0bab4b1c5e8a50e0c566b26b058512b93799335e8d581b8b5d16b6788cbdc"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d7c73d532c6598e401e6392b8cdc12d55a405832f3426fb6f62a6dbd2b58b811"
    sha256 cellar: :any,                 arm64_monterey: "512d31c28f75023f118fac4f44aef0f14e77146b73021d71d00384f320a34793"
    sha256 cellar: :any,                 arm64_big_sur:  "865fe5206731aa24e37560f5565f7fe5b9559ad907f2a00f18762aa7a98f48ee"
    sha256 cellar: :any,                 ventura:        "d41c04368ea3dadfdcf63cedf65bcad5af57464a155718f1717d5d451c5391f7"
    sha256 cellar: :any,                 monterey:       "e659eb809b167091de569ee8af7f9d1c5992cd035bafc18020844c071c06c063"
    sha256 cellar: :any,                 big_sur:        "903bf2098b93cfe35bf22a9f47064ab7faf3687f035a4c374f1b273674f3eb48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c19fe2290246b1ec1d75f2fa83b9ebb9f85cc676a1c34185d24dace9d1314c9a"
  end

  depends_on "cmake" => :build
  depends_on "etcd" => :test

  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "grpc"
  depends_on "openssl@1.1"
  depends_on "protobuf"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DBUILD_ETCD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port

    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <etcd/Client.hpp>

      int main() {
        etcd::Client etcd("http://127.0.0.1:#{port}");
        etcd.set("foo", "bar").wait();
        auto response = etcd.get("foo").get();
        std::cout << response.value().as_string() << std::endl;
      }
    EOS

    system ENV.cxx, "test.cc", "-std=c++17",
                    "-I#{Formula["boost"].include}",
                    "-I#{Formula["cpprestsdk"].include}",
                    "-I#{Formula["grpc"].include}",
                    "-I#{Formula["openssl@1.1"].include}",
                    "-I#{Formula["protobuf"].include}",
                    "-I#{include}",
                    "-L#{Formula["boost"].lib}",
                    "-L#{Formula["cpprestsdk"].lib}",
                    "-L#{Formula["grpc"].lib}",
                    "-L#{Formula["openssl@1.1"].lib}",
                    "-L#{Formula["protobuf"].lib}",
                    "-L#{lib}",
                    "-lboost_random-mt",
                    "-lboost_chrono-mt",
                    "-lboost_thread-mt",
                    "-lboost_system-mt",
                    "-lboost_filesystem-mt",
                    "-lcpprest",
                    "-letcd-cpp-api",
                    "-lgpr", "-lgrpc", "-lgrpc++",
                    "-lssl", "-lcrypto",
                    "-lprotobuf",
                    "-o", "test_etcd_cpp_apiv3"

    # prepare etcd
    etcd_pid = fork do
      exec "#{Formula["etcd"].opt_prefix}/bin/etcd",
        "--force-new-cluster",
        "--data-dir=#{testpath}",
        "--listen-client-urls=http://127.0.0.1:#{port}",
        "--advertise-client-urls=http://127.0.0.1:#{port}"
    end

    # sleep to let etcd get its wits about it
    sleep 10

    assert_equal("bar\n", shell_output("./test_etcd_cpp_apiv3"))
  ensure
    # clean up the etcd process before we leave
    Process.kill("HUP", etcd_pid)
  end
end