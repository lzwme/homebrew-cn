class ThorsSerializer < Formula
  desc "Declarative serialization library (JSONYAML) for C++"
  homepage "https:github.comLoki-AstariThorsSerializer"
  url "https:github.comLoki-AstariThorsSerializer.git",
      tag:      "3.2.30",
      revision: "7595f88ffdc621d73be4541205b66a2c44892dc2"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "515d2367842648ac0c27281d6d3efb56e75f17638fec4db1172145a80d2a5e48"
    sha256 cellar: :any,                 arm64_ventura:  "8bbba65e5c0c89c8c76b9b21ad9db8d0d469a0c6e5aa0b4b7524f381ecb73163"
    sha256 cellar: :any,                 arm64_monterey: "a5760714e3180af4a277f3c9ff1edb28cacad43eacec3e488f5f0f3307d07b73"
    sha256 cellar: :any,                 sonoma:         "672fc922c951d2f9dee08246e4d806308f97a729c0e457e7f93343d71559fdda"
    sha256 cellar: :any,                 ventura:        "7958d43eeee0b990f8e7020fac0c1b6839730247e8bcc7431cfc1cdcdd899bd5"
    sha256 cellar: :any,                 monterey:       "f5db265a13d1e5a34d16dc8e9968fdc27fabec73a57be082eb01010b51979a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad9c0d23caccff889466c587fe9c9bb95f2d5a75c4ce197ad1c81bc20737825a"
  end

  depends_on "boost" => :build
  depends_on "bzip2"
  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"

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
           "-I#{Formula["boost"].opt_include}",
           "-I#{include}", "-L#{lib}", "-lThorSerialize", "-lThorsLogging", "-ldl"
    system ".test"
  end
end