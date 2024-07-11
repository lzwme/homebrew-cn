class ThorsSerializer < Formula
  desc "Declarative serialization library (JSONYAML) for C++"
  homepage "https:github.comLoki-AstariThorsSerializer"
  url "https:github.comLoki-AstariThorsSerializer.git",
      tag:      "3.1.3",
      revision: "3b4fb77e05872d74eb7a1260e830c2d3c8f2407e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "69f36dd0f0542f5aadb6c4b8678fed9314f561cb206c0d0ed44b212077a3e251"
    sha256 cellar: :any,                 arm64_ventura:  "c8da7753214b0ec8a225130abb05e8d3f6c12a56632f5438a2eaea0c80eb5f39"
    sha256 cellar: :any,                 arm64_monterey: "d55821fa5b36106d51085a42804b73d3981ffc7782f4bb9ebafe26c58b413ad6"
    sha256 cellar: :any,                 sonoma:         "1aba8816b0aacdb0159d0406a6e5a053b2b3278cc503ac6b080352196a1cbf8a"
    sha256 cellar: :any,                 ventura:        "4e03837a5ecba36bc77ec8c8af3e9707fe4ba65aa02e07c553e619e6c4355778"
    sha256 cellar: :any,                 monterey:       "07ce53c8fe96e5bbb74d439345b9852ef65784700783b55607d9996d626133f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1213e7a47acdb20e568da485b3600ed5b607a0ccfd852e176a10bca636be3ae"
  end

  depends_on "boost" => :build
  depends_on "bzip2"
  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    ENV["COV"] = "gcov"

    system ".configure", "--disable-vera",
                          "--prefix=#{prefix}",
                          "--disable-test-with-integration"
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