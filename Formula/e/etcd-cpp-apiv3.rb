class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://ghfast.top/https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "4516ecfa420826088c187efd42dad249367ca94ea6cdfc24e3030c3cf47af7b4"
  license "BSD-3-Clause"
  revision 28

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec7d3ba040a88e65e5e693713805e90b8e050cf5e48782699a9225e5e3f24ed6"
    sha256 cellar: :any,                 arm64_sonoma:  "758f8a46651629cace3c782ab5b642df9aff0427f6c710a2725414d7db215ec3"
    sha256 cellar: :any,                 arm64_ventura: "8d8d8a5e30fd0e411b1cdf1d6aca970d31397d4e375a846150d2aa647d341197"
    sha256 cellar: :any,                 sonoma:        "8e6b747c2a58aa9a300b220ad2d93d37498d77b1fb3fa336002c865487d1a29b"
    sha256 cellar: :any,                 ventura:       "dd443e3a3da3d6fce51eb48a8d8502d0723d3a8b6076c97377bc67cfbd02e03e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a91198b33d6f064546e2cc64204166f80b7659a999cd93f5fb77fe4cd7e4f0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eae0bac05fb129f47f85ef76042f1b414d6aad9ccd918eebd931caaa3d62ab33"
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
  # https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/pull/281
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/ece56adf4d01658a5f0668a3618c97153665581c.patch?full_index=1"
    sha256 "f3686647436045a9a53b05f81fae02d5a5a2025d5ce78a66aca0ade85c1a99c6"
  end

  # Backport cluster manager api needed for newer `vineyard`
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/17d7b60194e5b6d9005bb10947905a393f432624.patch?full_index=1"
    sha256 "b0d1bce10cf2f03124af744f2a184162b6b555b09d162b8633ed8ab9b613f8f8"
  end
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/3ad17314d6e8c26beb88501f8e74e506ccaf26b8.patch?full_index=1"
    sha256 "52dd6132b03c4c1210bb1c0b8a32ff952f84b198d612903c10a53b7a4f5ce2b9"
  end
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/ea56cee80f441973a0149b57604e7a7874c61b65.patch?full_index=1"
    sha256 "bce8ef02bc56f2ac430d580191217ff78210cc6e261d29c7031a22e65cd05693"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DBUILD_ETCD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port

    (testpath/"test.cc").write <<~CPP
      #include <iostream>
      #include <etcd/Client.hpp>

      int main() {
        etcd::Client etcd("http://127.0.0.1:#{port}");
        etcd.set("foo", "bar").wait();
        auto response = etcd.get("foo").get();
        std::cout << response.value().as_string() << std::endl;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      set(CMAKE_CXX_STANDARD 17)
      project(test LANGUAGES CXX)
      find_package(protobuf CONFIG REQUIRED)
      find_package(etcd-cpp-api CONFIG REQUIRED)
      add_executable(test_etcd_cpp_apiv3 test.cc)
      target_link_libraries(test_etcd_cpp_apiv3 PRIVATE etcd-cpp-api)
    CMAKE

    ENV.delete "CPATH"

    args = %W[
      -Wno-dev
      -DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"

    # prepare etcd
    etcd_pid = spawn(
      Formula["etcd"].opt_bin/"etcd",
      "--force-new-cluster",
      "--data-dir=#{testpath}",
      "--listen-client-urls=http://127.0.0.1:#{port}",
      "--advertise-client-urls=http://127.0.0.1:#{port}",
    )

    # sleep to let etcd get its wits about it
    sleep 10

    assert_equal("bar\n", shell_output("./build/test_etcd_cpp_apiv3"))
  ensure
    # clean up the etcd process before we leave
    Process.kill("HUP", etcd_pid)
  end
end