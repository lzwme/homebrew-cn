class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "9.1.3",
      revision: "5de21808a22aa3aa7405fafae7bde8992ba64d4b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d08d6b7283fa2a120072770cf32ef84fbada6eae98bc0febf33623a6bf3beef"
    sha256 cellar: :any,                 arm64_sequoia: "1a86856f71fa6b3d15a5f9185b4e0c41d049e4efb3f3f9fb13c8283feb5d5235"
    sha256 cellar: :any,                 arm64_sonoma:  "1c84e2421cbf8780e0246902085d2dea5acc8e49a47fa1ed87b7bc3d070fa17a"
    sha256 cellar: :any,                 sonoma:        "6e3a0b9a3b7c83b8df01e430f409d4152b71a8eb9433c93148139bf11e309242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f64aa2f8da2400dc409327235f575f4931e0dece334346c353f8dbc54c9c586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82766ef6b54700ec6fb4c6ccc6982fc0f389cf854fdd896cf1883543bad4a8a8"
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