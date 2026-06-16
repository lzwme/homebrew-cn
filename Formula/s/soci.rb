class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-4.1.3/soci-4.1.3.zip"
  sha256 "2760b6d4007a5fbfdd9c1fc00854dd39c430aacc201786fb01680a55311d6585"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/soci[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_tahoe:   "75a8d9581af0f5b09555e9501de9df2bb4594de4a626589218873ec6dbef1bf6"
    sha256 arm64_sequoia: "9c684c9d4df6579311e2fb176bf7999d59312ff6bdb0a120139f030a9b5ae085"
    sha256 arm64_sonoma:  "ea7f462b5eeb680c866d8a185b08e01b288a6f73975356239183c4764bd2af84"
    sha256 sonoma:        "bd225ec31c4456cc23d85499df2098953b92c6cf288d293f26202cb59e4be130"
    sha256 arm64_linux:   "66b0312a4e841b1b72f77b4301d4faa641ced6c10a87936512e99d4bc4cb0a03"
    sha256 x86_64_linux:  "8d800860c618099b86b914675af36e64def2ef283b5fe24bdeab31b90a68bef0"
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