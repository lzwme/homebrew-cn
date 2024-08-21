class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https:github.comLoki-AstariThorsMongo"
  url "https:github.comLoki-AstariThorsMongo.git",
      tag:      "3.3.01",
      revision: "dfe2a57a71b5f2b93022b60d0c3c5acec2b5a40c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50e6129f5cfd870a1a60e5f471bf51c71d271490244089ce21c6104482785fa2"
    sha256 cellar: :any,                 arm64_ventura:  "2b928920957bc542b97df1107f5bac195d43af2124ae0cf39d538f3fc8cc14c7"
    sha256 cellar: :any,                 arm64_monterey: "9b9c2da175c175c03b364c8c844daed710daeaa98818d8c12a1cb7ce7e4133de"
    sha256 cellar: :any,                 sonoma:         "3b61c9e2045ef156f568e3f8d77bb2740ab68f605907b0269772f03fc7abe503"
    sha256 cellar: :any,                 ventura:        "76ed928d6a0b63c6187b97c6397d6cccbaf3c759a49f8c7aff33023ae35192d3"
    sha256 cellar: :any,                 monterey:       "fd012b3ff3bcec50e2f3c9a0d9132e0722f8ee0b8387481a2f3261822128761e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "760649915a51ba5be94736fa22751a2f913e15a7a766af74c33133ef1e1e3a0b"
  end

  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    ENV["COV"] = "gcov"

    system ".brewinit"

    system ".configure", "--disable-vera",
                          "--prefix=#{prefix}",
                          "--disable-test-with-integration",
                          "--disable-test-with-mongo-query",
                          "--disable-Mongo-Service"
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include "ThorSerializeJsonThor.h"
      #include "ThorSerializeSerUtil.h"
      #include <sstream>
      #include <iostream>
      #include <string>

      struct HomeBrewBlock
      {
          std::string             key;
          int                     code;
      };
      ThorsAnvil_MakeTrait(HomeBrewBlock, key, code);

      int main()
      {
          using ThorsAnvil::Serialize::jsonImporter;
          using ThorsAnvil::Serialize::jsonExporter;

          std::stringstream   inputData(R"({"key":"XYZ","code":37373})");

          HomeBrewBlock    object;
          inputData >> jsonImporter(object);

          if (object.key != "XYZ" || object.code != 37373) {
              std::cerr << "Fail";
              return 1;
          }
          std::cerr << "OK";
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++20", "test.cpp", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lThorSerialize", "-lThorsLogging", "-ldl"
    system ".test"
  end
end