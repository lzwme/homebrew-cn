class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.2.0-src.tar.gz"
  sha256 "9424668225c5a73f7b7805cd36d75d8502c9a8e20ca11c952653155ef6e909da"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "38c462d4902e2593c52648dc7725ef3a28dbd84b74b147c4c7ca778e8e727598"
    sha256 cellar: :any,                 arm64_ventura:  "86e38a20cd83dacbebf4503e8188fd3a01cb55e306c77f29d2b55946e3c0c612"
    sha256 cellar: :any,                 arm64_monterey: "ab716aa33e78816b2d5bae55d124e288ca19f9bc42bdef25c40bfda0a41bd7d8"
    sha256 cellar: :any,                 sonoma:         "0d26057b3591c4fecc3a428be7277af676f50268fa39a4d2c05446a46489b86b"
    sha256 cellar: :any,                 ventura:        "aac513ea6f9b0fca736de943678c51f9072cd9fb4abe7cda48a22b89d5ab6f63"
    sha256 cellar: :any,                 monterey:       "cf1128323ebe9f0063b0bb15143f7d872c7d5658c88a38bdfdce9ba4ac2059d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1dbdc43738517ad71029341448af85b0e177290a1d4a15afe9d5214010581a7"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "mysql-client"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DINSTALL_LIB_DIR=lib", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <mysqlx/xdevapi.h>
      int main(void)
      try {
        ::mysqlx::Session sess("mysqlx://root@127.0.0.1");
        return 1;
      }
      catch (const mysqlx::Error &err)
      {
        ::std::cout <<"ERROR: " << err << ::std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lmysqlcppconn8", "-o", "test"
    output = shell_output("./test")
    assert_match "Connection refused", output
  end
end