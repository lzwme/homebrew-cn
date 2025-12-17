class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "8.0.02",
      revision: "6b978082056e1602ce6fb7b5f849c3e66c09f94e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d1ab5584eb9f49de7fabf424f87eb99b1093b60b091697afc9c9a52d3fbd39f"
    sha256 cellar: :any,                 arm64_sequoia: "2488a6b4c438730689a96d191f4b3954cfd928de2c8f7dc24cfa50c9783c0c60"
    sha256 cellar: :any,                 arm64_sonoma:  "e61212ba929d3f2c5be2aff3993ae8a57fb2808382a6ee25e3eb5204a67fb341"
    sha256 cellar: :any,                 sonoma:        "5409a6b22e0dd7b59f782df8fd54cced90ca816dc4b9ab5a2bb9f900c95b8b5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3937f2bfe3f76a68d2084f4942d19e2501b9049782cc238e66ea314eb0c90911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94cfd4096dae3b44612e06e3b9d493120b761aefa4131efaf328f7b7b5a8d032"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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