class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-4.1.1/soci-4.1.1.zip"
  sha256 "b59bc01ec20fd9776cdb071f600acbe66b5a3f3350561abb97f5707649921d9c"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/soci[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_sequoia: "52ef9b3f00b41eb6ce74b96700fa573ba5b7e310be4c35138484efb322669556"
    sha256 arm64_sonoma:  "7b09d3822744eb4ab4360a6ec309fe8faaf7258f6f15ee6dbad0de4b9354d76d"
    sha256 arm64_ventura: "db67c0d06a017cfdce97066f2d6fb69e2d59c7daa2c7677f68900a8e95390649"
    sha256 sonoma:        "4d7b3fdf3c82a65f37fcb50cd3937c180abc7980c68adc6f2216519a4926c099"
    sha256 ventura:       "84d2bb89ce70ba3a26f302a69b06b4a72057dfc99412595f8a56106d565f53d6"
    sha256 arm64_linux:   "29a9b223156659e2533f0164962f043c80c10ee1537dea870341057059ac9311"
    sha256 x86_64_linux:  "a4df53be23c078dc937baa5e1aef8c86c4cc432e9cd39e63d59a8d18a039778c"
  end

  depends_on "cmake" => :build
  depends_on "sqlite"

  def install
    args = %W[
      -DCMAKE_CXX_STANDARD=14
      -DSOCI_TESTS=OFF
      -DWITH_SQLITE3=ON
      -DWITH_BOOST=OFF
      -DWITH_MYSQL=OFF
      -DWITH_ODBC=OFF
      -DWITH_ORACLE=OFF
      -DWITH_POSTGRESQL=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~CPP
      #include "soci/soci.h"
      #include "soci/empty/soci-empty.h"
      #include <string>

      using namespace soci;
      std::string connectString = "";
      backend_factory const &backEnd = *soci::factory_empty();

      int main(int argc, char* argv[])
      {
        soci::session sql(backEnd, connectString);
      }
    CPP
    system ENV.cxx, "-o", "test", "test.cxx", "-std=c++14", "-L#{lib}", "-lsoci_core", "-lsoci_empty"
    system "./test"
  end
end