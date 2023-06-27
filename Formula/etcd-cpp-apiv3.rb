class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  # TODO: Check if we can use unversioned `grpc` and `protobuf` at version bump
  url "https://ghproxy.com/https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "5faf1ca697f9889c269a2a0cb2237d8121959f72bf6eca4f61dffdcb9c6d9d46"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7dc7f7ec41ef3db07ad0823cc17c4d013efc2fd42ad66a05fdfa090bdde0501d"
    sha256 cellar: :any,                 arm64_monterey: "0d17c5125fbd3aed229c7ef749c7081791fcacc2435f10b68ca235ce97770dc5"
    sha256 cellar: :any,                 arm64_big_sur:  "9ac3639b147355beca8477645573d4cfb5811ba938c32707fbc0e05e0cafa831"
    sha256 cellar: :any,                 ventura:        "14d96b67ddf79fb76597aaacd4c38aed2b4715716eed1036424c6521c0453da0"
    sha256 cellar: :any,                 monterey:       "023c7b8f722d48f40fbd27a4857055ea813d52cfa51fcaba023fd9c58a81bf5d"
    sha256 cellar: :any,                 big_sur:        "8db60fbfb71709abf50a47c60823f195554ae4e406d428188340664ec9940e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d81ecaa09dede0638201bdcbfb435955eb46be27ce750a8af0382d1bffb780be"
  end

  depends_on "cmake" => :build
  depends_on "etcd" => :test

  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "grpc@1.54"
  depends_on "openssl@3"
  depends_on "protobuf@21"

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
                    "-I#{Formula["grpc@1.54"].include}",
                    "-I#{Formula["openssl@3"].include}",
                    "-I#{Formula["protobuf@21"].include}",
                    "-I#{include}",
                    "-L#{Formula["boost"].lib}",
                    "-L#{Formula["cpprestsdk"].lib}",
                    "-L#{Formula["grpc@1.54"].lib}",
                    "-L#{Formula["openssl@3"].lib}",
                    "-L#{Formula["protobuf@21"].lib}",
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