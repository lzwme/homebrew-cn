class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https:github.comLoki-AstariThorsMongo"
  url "https:github.comLoki-AstariThorsMongo.git",
      tag:      "4.0.01",
      revision: "8befc0ec157059226fe8442cc5a0b5701eeb69b5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e579a3c3e36c9e81e55e106101826906d897978d7082103709a45cb3175c0b8a"
    sha256 cellar: :any,                 arm64_sonoma:  "627089734079639e262c99f6cefdf57d19909585e3994488624d162b4a36c837"
    sha256 cellar: :any,                 arm64_ventura: "b5fd0fe62bf2dd5cd1d07584fbce8231e2e179e31785ed43931b5576bf067649"
    sha256 cellar: :any,                 sonoma:        "f3ca54cbead2f3e1d4e604dcb3b39011eedda88a98a59610cfb5ce73773a5a2e"
    sha256 cellar: :any,                 ventura:       "7967d41d7d92bebd840558d9a39711399b19fe567a27965f31495f3a41172987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c2841d0b3166ca513facfeb78c70b6b1ee8a60619658c7de2ad96582b4ba447"
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