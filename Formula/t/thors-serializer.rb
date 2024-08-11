class ThorsSerializer < Formula
  desc "Declarative serialization library (JSONYAML) for C++"
  homepage "https:github.comLoki-AstariThorsSerializer"
  url "https:github.comLoki-AstariThorsSerializer.git",
      tag:      "3.2.20",
      revision: "1b039a138ad42fbf2e84f077be4442500df84b8a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bb011270fa90a0068d77b352765dd38ba3e42ac8cc051c45b41fbb4096d0a46f"
    sha256 cellar: :any,                 arm64_ventura:  "ed6b244c323e90ce39f32a26706157240a07b449806573f59832804105684f86"
    sha256 cellar: :any,                 arm64_monterey: "7b71fee98e407f9f4b5d1d30cad96b68adae6259979cf174fba259880c5508a5"
    sha256 cellar: :any,                 sonoma:         "b1cb518a37e11e1513f5efab34756847b3416db0f899c5c485e528cb7fe21a99"
    sha256 cellar: :any,                 ventura:        "b739301dce42eb720f06ebab7496c6e6bbfca6d3226a60907a20571e35e02bd4"
    sha256 cellar: :any,                 monterey:       "f5474aced958ee5f88cdb9b099ddf83006ef6f4af366206496375ffa46bbc109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87589071e49243aecadbbc784b45a840af666ad1a2efb07acd1cc75bc6965e36"
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