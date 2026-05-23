class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "10.2.1",
      revision: "e24214a39762dc262741cfcc6721c9ded9bd76aa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96502f8791ae60d8de450ed66e0b5067b511146359c99074429b0a8d3b9a1e0e"
    sha256 cellar: :any,                 arm64_sequoia: "621ceaf14889b12b1772d1495f545a952e9dae1626942f560d3f76b26a53e0ce"
    sha256 cellar: :any,                 arm64_sonoma:  "4d979f73da2b1c30a253646f79d972d7b070105b48e0095b5a9b9ccad0b6b2b6"
    sha256 cellar: :any,                 sonoma:        "0b2e24df98abc0089da7e543f004a44d20c2ffb65d92192afcf9e82e66043c4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4593d08a526821e3d0a025f4fd0b387d70a0fce71dcd2e25e93c547820123ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f5636c37c864d947424c968f23bf6375d31b5fefb7da61d16d235f62019958c"
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
    ENV["DISABLE_CONTROL_CODES"] = "TRUE"
    system "make", "-j", "1", "JOBS=" + ENV.make_jobs.to_s
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