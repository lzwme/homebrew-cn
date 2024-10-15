class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https:github.comLoki-AstariThorsMongo"
  url "https:github.comLoki-AstariThorsMongo.git",
      tag:      "4.5.02",
      revision: "f8e71f06d6a1f541b858b8a85d5b8a9bdd7be8a4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "465b58b204932cd16457b88bcfce136a661a75d4f7c9634f3191779156d89d44"
    sha256 cellar: :any,                 arm64_sonoma:  "4790ca98e3a7d379a2eb3a19e4972cfbdb92699db28b33fa9a5f2e633b30792b"
    sha256 cellar: :any,                 arm64_ventura: "d32fa675865ee0a73a3a040b444b571b2b0129415352b6d0c21c137816109c36"
    sha256 cellar: :any,                 sonoma:        "9d3d9be81af02ed291612a23a93ea76c4f85a3c5e5d07928d296eb06b1a95aea"
    sha256 cellar: :any,                 ventura:       "15d613a81c72f1efd7243f96f1f188580124609545ce7400f1d27c7b46337834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be622227f6ba81056a8a982a3019fa6661df7a859d62525d54c7c6d1ed627d85"
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