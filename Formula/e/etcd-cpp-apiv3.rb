class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://ghfast.top/https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "4516ecfa420826088c187efd42dad249367ca94ea6cdfc24e3030c3cf47af7b4"
  license "BSD-3-Clause"
  revision 30

  bottle do
    sha256 cellar: :any, arm64_sequoia: "4d2272c8a0aba3518c44333ac92798165eb18dcd40860024d349bbc172ebbb08"
    sha256 cellar: :any, arm64_sonoma:  "f0ab5749188db2938c2e568524da80d31beff832566e5de09db940a6a5e8979b"
    sha256 cellar: :any, arm64_ventura: "76cfe1f9d5be0176de8ffd9ae0c0f779ee397724109baf74a7f4dbb6b8ad7a78"
    sha256 cellar: :any, sonoma:        "5f75c4ab7f199c0df7548b3e542c5005ca0cf37b5834d0b046036f43a9b07bfe"
    sha256 cellar: :any, ventura:       "e538f468b3676467766e78cc38b3fa667fcad42aa644467e3b16aa2da4af2f9d"
    sha256               arm64_linux:   "71b28ec67871747111fa7071448a120496eb103bdacca6fb5a758f9a8c6b3f5e"
    sha256               x86_64_linux:  "5acb1af62c9b0e9010c0e628a9329bfc75511175f137b62db7a888921610274c"
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