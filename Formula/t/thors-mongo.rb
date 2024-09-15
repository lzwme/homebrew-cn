class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https:github.comLoki-AstariThorsMongo"
  url "https:github.comLoki-AstariThorsMongo.git",
      tag:      "4.0.00",
      revision: "778a25351ad6b1dd9b142678ce6c234fc21aa211"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c043c010a2f7697e392bd7bf2b2d9c970a57f10bbedce7a72c8986adff4e086b"
    sha256 cellar: :any,                 arm64_sonoma:  "5c8e418f8baba079538761a70cd097a72aafcadb15a50c753d80014ff5b09ba6"
    sha256 cellar: :any,                 arm64_ventura: "ff4169b6bd03c2d98bacbb4f46a0beb1abc897cbe0ba5ae10768f6906dc750d3"
    sha256 cellar: :any,                 sonoma:        "6a1a99d1e46317afe5e8a39a05ae1b858408c3acaa3e9bc291b93bb1e2ce670b"
    sha256 cellar: :any,                 ventura:       "e649f752c5e180d37be483e54bd6afbdb852f31d560e4993bbb69d95c9eb9ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d92c9399ab71af3763e6375d116c2e1b0125310db4015f5aa04f07f72c48699"
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