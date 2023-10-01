class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://ghproxy.com/https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "1a6f4ed634f3c75cbfaa2768917e280c6df77cac2af5d945ad67ef20d53d8b60"
  license "BSD-3-Clause"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4e52cb38887ccfc0241fabcacbb04ffb90a8ea6046abe0ede60ea4ec96acac9"
    sha256 cellar: :any,                 arm64_ventura:  "a8a195cbd8f80687208cb4065bff6b7e3fd391d76382106164f6323299d4a3a3"
    sha256 cellar: :any,                 arm64_monterey: "5c4f1c7ce652ce044feac098f5275941e90df661974e3756a9d8920b731d6c31"
    sha256 cellar: :any,                 sonoma:         "4b4cafe9662a4c584801cfc094b43271cc495bef8f2e4a1fe5769e850ddf26b4"
    sha256 cellar: :any,                 ventura:        "deafef3c56a6f5132e2ae8c3dd480e1b0fca998d8a1abdcf0d080b5e536fdc23"
    sha256 cellar: :any,                 monterey:       "44faf8da8f89a6ba5f9d17b08fe3a82b24e9587d9d384016254b3cf8dca27660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d2202d4df212fe805faec95474b178de56e952add60d2dbc9a2afcb39426308"
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