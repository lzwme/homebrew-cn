class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "9.1.0",
      revision: "9fec4ca7b2649def629bd0cd44073bda6a1f17a7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33a249e118519c343e6e9c5026cfbcd0da41c4c3c8dbb77cd001823f8e73999d"
    sha256 cellar: :any,                 arm64_sequoia: "97bef39414dec5c6ee70486a6cdbedbc6dad3ad647188cf95d38150356452d15"
    sha256 cellar: :any,                 arm64_sonoma:  "9b69d9908e6374e0b17c6364014445ffedfeb14035e591d4dad804c136e0fdb9"
    sha256 cellar: :any,                 sonoma:        "08ce4ec66aae4d30b58c6ee94a7a87c656dbc40f557531a56740718ba1befaa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab321b824f889d624c151bee80a02efb1765e2d943886bfedf48343c02493654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32cbcdf153e1534585575b52e90a0d1b9e7014d7f7a024416733bd10b11adec7"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["COV"] = "gcov"
    # Workaround for failure when building with Xcode std::from_chars
    # src/Serialize/./StringInput.h:104:27: error: call to deleted function 'from_chars'
    ENV.append_to_cflags "-DNO_STD_SUPPORT_FROM_CHAR_DOUBLE=1" if DevelopmentTools.clang_build_version == 1700

    system "./brew/init"
    system "./configure", "--disable-vera",
                          "--disable-test-with-integration",
                          "--disable-test-with-mongo-query",
                          "--disable-Mongo-Service",
                          "--disable-slacktest",
                          *std_configure_args
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "ThorSerialize/JsonThor.h"
      #include "ThorSerialize/SerUtil.h"
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
    CPP
    system ENV.cxx, "-std=c++20", "test.cpp", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lThorSerialize", "-lThorsLogging", "-ldl"
    system "./test"
  end
end