class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https:github.comLoki-AstariThorsMongo"
  url "https:github.comLoki-AstariThorsMongo.git",
      tag:      "3.3.02",
      revision: "4a0cea819016026bb8145b1e6b675e70fac0899f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9cf15876e479331e83f008157d3c5995b36a6ca9ee0c6730782f9a094a284cb0"
    sha256 cellar: :any,                 arm64_ventura:  "dc452165a8c7ee7ead6d3c8017db62941cc98728afb28d5487148da8686f53ff"
    sha256 cellar: :any,                 arm64_monterey: "50617bbfb0515d1ca19a75da5b3b3bd2bdddec9bc4826c5a9be25028b6ed2ea5"
    sha256 cellar: :any,                 sonoma:         "ef225fe2564197de44c58ba4d58e0ee2187409cf7a484aefd9a1bea01b7bc2ee"
    sha256 cellar: :any,                 ventura:        "49834f1217d7e997d5adc8e8ea78377c60dc43addbd8a69af4f81f60b1680f96"
    sha256 cellar: :any,                 monterey:       "c5e24c3236bf4d42f7310d0e357e282c1145ebd859c581e5faf5acc1e0e78ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6b180936862fff075a1d9c582a0ab25dd231e3148a35edfb047717aa48011ce"
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