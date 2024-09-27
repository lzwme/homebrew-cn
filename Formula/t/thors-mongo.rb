class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https:github.comLoki-AstariThorsMongo"
  url "https:github.comLoki-AstariThorsMongo.git",
      tag:      "4.3.00",
      revision: "37f11c9e9426b21136d1337cd4e6c5d0c5b71967"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e9017ccb37ea3c2ed2aea98ab47c83b9e38d6efb413ada227a02246746762c53"
    sha256 cellar: :any,                 arm64_sonoma:  "70888b3bfaada2dd06eeb32d3dcdc8603d5b3b8858f73e3b486a84e7edc99f8f"
    sha256 cellar: :any,                 arm64_ventura: "6c4f2697e44f5688393517170b08bcec639e7ac42619fd5e3f8d2837cb41147c"
    sha256 cellar: :any,                 sonoma:        "5ff46bb6d3b72f7cf9f8f4676c365264e552302b49af66072b865fb98a218b9d"
    sha256 cellar: :any,                 ventura:       "185909cf9dcbe3ea3294eef15ee49e44d8677844233156fa037e46028e4b4707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f24213994777a8e8e64e149b789e55bfc8e24fcd028c0a9c0d0eb510b7198000"
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