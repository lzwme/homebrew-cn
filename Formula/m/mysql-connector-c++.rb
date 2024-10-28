class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-9.1.0-src.tar.gz"
  sha256 "70fb6ca28ac154a5784090b3d8cc4f91636c208cf07c0000e3d22f72b557be13"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa6ade504277d3b6ebf8398ab34e4660b36cacaf68f5c9c73eacf62c3d6e5a71"
    sha256 cellar: :any,                 arm64_sonoma:  "baaf6c94e9737b438d72163723d10371f929d41d9198982beaea24146f00b4c8"
    sha256 cellar: :any,                 arm64_ventura: "44180c3c927e34b69e002ab693d5c70fee42f93ab2f3e5649f1918964f996ff7"
    sha256 cellar: :any,                 sonoma:        "1f1f78f79e2092b73d4b8bf40b8928e05fa9b8ccf940d1e6fb7ac20d4975f7e0"
    sha256 cellar: :any,                 ventura:       "981b1f46457bdd762cce824b7a6aca648eb81ca9bb6305439f957399ba1df218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ddd4cb5fd3252d55eaccd437d45acf06606f0ef04a3bddf59b34aab23aa4369"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf@21"
  depends_on "zlib"
  depends_on "zstd"

  def install
    args = []
    %w[lz4 protobuf rapidjson zlib zstd].each do |libname|
      args << "-DWITH_#{libname.upcase}=system"
      rm_r buildpath/"cdk/extra"/libname
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
                    "-L#{lib}", "-lmysqlcppconnx", "-o", "test"
    output = shell_output("./test")
    assert_match "Connection refused", output
  end
end