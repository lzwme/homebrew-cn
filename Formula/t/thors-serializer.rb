class ThorsSerializer < Formula
  desc "Declarative serialization library (JSONYAML) for C++"
  homepage "https:github.comLoki-AstariThorsSerializer"
  url "https:github.comLoki-AstariThorsSerializer.git",
      tag:      "3.2.6",
      revision: "880bbec133a71d20ede5a16f248d787ad56c5439"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d039cf926418cd0287b1739ffacfa4125859cb9c88f0cd47e6c9dfedb5695a8c"
    sha256 cellar: :any,                 arm64_ventura:  "0c91e982aec5534a4e256f75a728764ada09f62fce9fd9d3fba39eca50e617c7"
    sha256 cellar: :any,                 arm64_monterey: "01444f17339e3f016a2700fed971e22deee389d7b4975ca4cd5135a3d30cd353"
    sha256 cellar: :any,                 sonoma:         "599863f8cf119566d6aad73bf425de9705ded677b3ac9dd4fce4d574ef0d2c55"
    sha256 cellar: :any,                 ventura:        "474628ee4a6c3e7036369a9e64335ecef85b9f2bee9c4a8d05ee8305721e2bb6"
    sha256 cellar: :any,                 monterey:       "b017968a17cfe644688627353ee0a942c24967f12075524db617bfff08e0af1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f80447cffc9f86968bb571f3969d8e26aff827c385159484a37ed0378ac8e7bd"
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