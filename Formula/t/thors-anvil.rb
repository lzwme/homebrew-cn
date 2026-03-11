class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "9.1.5",
      revision: "b4ef98aa8dd007ee0b7c23cdd65e6e9d2342da8a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e53cd9dc0bd4ce5c39b6e481078589b00c6c35231ff864e5907fa469bb1239b7"
    sha256 cellar: :any,                 arm64_sequoia: "20b3114d3632936a64809da7a6f4da9d41194a1b67f054fa567046d7449be36d"
    sha256 cellar: :any,                 arm64_sonoma:  "a74468f2cb9b91b76a76f136124dcb3b3eb0f4f37243b336692f8d32cd37903c"
    sha256 cellar: :any,                 sonoma:        "60c805810d1fb1e5641b5d8552b345fa92762064c26d834285a6cb62a7eddf4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13abba03ddb8f53c5ad7e20c67ac88daf474040a6e40937a00c83b66d49a1a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb0ee384c3f6fffe89fa97765c401b49cc1ef27d0f87c567abd3c0da323b654"
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