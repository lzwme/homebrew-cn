class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://ghproxy.com/https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "1a6f4ed634f3c75cbfaa2768917e280c6df77cac2af5d945ad67ef20d53d8b60"
  license "BSD-3-Clause"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9b1c57a0d188ce277279426ec13fe87800ec6389aa8e1d3267a7e305dbc5c534"
    sha256 cellar: :any,                 arm64_ventura:  "723f802b01037be4eafb3c6f0e1ce4d7a19a9e3b1c69d5cd5a704acb8802ed64"
    sha256 cellar: :any,                 arm64_monterey: "737951d13bafe1215aebabe9f7c88d58b9b0cd26360d6f9192da34f2517bb631"
    sha256 cellar: :any,                 sonoma:         "a2b7ea778f563b3fb82255c5e5bdf38414bf4e4ac7c32906f16fb7eb9e21c103"
    sha256 cellar: :any,                 ventura:        "40cce3850228f69c2e3f1685bcbfe2867b9f16394211e4bb14805e9cba7b3cdb"
    sha256 cellar: :any,                 monterey:       "e87c848063155cce258e90552e8fec2b65a38eee937d6168ef0f34b6747f14ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff0c8fa1c324bdf1879375b04d11fdad72948b0e3a637f6b7153c6b43c390052"
  end

  depends_on "cmake" => :build
  depends_on "etcd" => :test

  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "grpc"
  depends_on "openssl@3"
  depends_on "protobuf"

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
                    "-I#{Formula["openssl@3"].include}",
                    "-I#{Formula["protobuf"].include}",
                    "-I#{include}",
                    "-L#{Formula["boost"].lib}",
                    "-L#{Formula["cpprestsdk"].lib}",
                    "-L#{Formula["grpc"].lib}",
                    "-L#{Formula["openssl@3"].lib}",
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