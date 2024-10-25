class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https:github.comLoki-AstariThorsMongo"
  url "https:github.comLoki-AstariThorsMongo.git",
      tag:      "5.0.01",
      revision: "68cd8a339c69e255791c253b2f88f3e02f10cb9c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a00b7fdbd42b9d2a007152d96ccb87161ab02058af041abc578e852da094557"
    sha256 cellar: :any,                 arm64_sonoma:  "254da181be66cb9478fbd7a32818747337260995a600a863cfeb09d4d6aca358"
    sha256 cellar: :any,                 arm64_ventura: "c490fcc8947106e256d5bcf0fcaa28a1636a69bf45834801c2d9b406fe5b6770"
    sha256 cellar: :any,                 sonoma:        "6faefb04ad28d380ca4ae34f3f07f0b13ce45e7531cb671492f1e9043d87bcbd"
    sha256 cellar: :any,                 ventura:       "4e640a4a04bb1943b656db15c88ccb5c082f4ab95c8fcc4fa22c951046e6fd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b5c58465dfd54c68c04bbc7bf7e416e5671a26aabc242629ec90dd12f9f879"
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