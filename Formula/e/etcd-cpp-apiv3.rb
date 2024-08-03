class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3"
  url "https:github.cometcd-cpp-apiv3etcd-cpp-apiv3archiverefstagsv0.15.4.tar.gz"
  sha256 "4516ecfa420826088c187efd42dad249367ca94ea6cdfc24e3030c3cf47af7b4"
  license "BSD-3-Clause"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2f2ba000b41617a88fa5b3b6b485e86589e36d6611a87870f698f8dfbe43a6c5"
    sha256 cellar: :any,                 arm64_ventura:  "901b7dcdf7e7042e75f3e1e85fa5840c2051b50cc98d80aee43226bc9d1a9ae7"
    sha256 cellar: :any,                 arm64_monterey: "1061e0f35751328b59118d10922f221a9efc2c4200d210181cccd01eeeb71390"
    sha256 cellar: :any,                 sonoma:         "3427e7ee67cea3c38a332bdc12d8c6ad75546fc3e508739c646851e4fec15ecd"
    sha256 cellar: :any,                 ventura:        "a5fd729038c52fc87670d332f5d1e2bba8d22d658c8fe813ef4bde6b690ea927"
    sha256 cellar: :any,                 monterey:       "106ed5871ee052c28dfe3bd2065425f57d734502c6b861e36eb7c747b2ffc7ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2660dddd2fbd979cb7ef29b1ef66445a14868c99883dc992d3594c5fca1e8f6"
  end

  depends_on "cmake" => :build
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
      exec "#{Formula["etcd"].opt_prefix}binetcd",
        "--force-new-cluster",
        "--data-dir=#{testpath}",
        "--listen-client-urls=http:127.0.0.1:#{port}",
        "--advertise-client-urls=http:127.0.0.1:#{port}"
    end

    # sleep to let etcd get its wits about it
    sleep 10

    assert_equal("bar\n", shell_output(".test_etcd_cpp_apiv3"))
  ensure
    # clean up the etcd process before we leave
    Process.kill("HUP", etcd_pid)
  end
end