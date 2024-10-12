class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https:github.comLoki-AstariThorsMongo"
  url "https:github.comLoki-AstariThorsMongo.git",
      tag:      "4.4.04",
      revision: "0ec3b252dd1995bcd36823c5762aab6c12c5ac7d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b7ded39a916228bb95f7d5a067318223d412cdce0a5f446035282d730cdd7824"
    sha256 cellar: :any,                 arm64_sonoma:  "ba1191422f53ddb048339ae16c48247703634201bbc0ce9e197d2b4f2164867d"
    sha256 cellar: :any,                 arm64_ventura: "e1c3e3dd332afda5411a8b9a26903642a496cdd8a4b83810934399d05ca77392"
    sha256 cellar: :any,                 sonoma:        "440d289e30d7da1c70385194f7a0c24bc97ee80412516fcbcf99a7e883f059db"
    sha256 cellar: :any,                 ventura:       "15d24d20e7f3733c56557be959b7cc5a05e190b0533ca77b38136a294563c04c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f11f569e21b4177400c632a05efa11a8f77375ce4c01b4bfec4cb8ef098c147c"
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