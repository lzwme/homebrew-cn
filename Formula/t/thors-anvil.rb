class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "9.0.16",
      revision: "88d1bf13c87b8371bd1cbdb9b5b59f162f695df8"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca930794c6bb1ca47779a4160e81c7732cf24cc11878fec297a0c39d7ab72fca"
    sha256 cellar: :any,                 arm64_sequoia: "f58b0a7cc30237daef250ac5648df6f8913f5055f5520b8f72e1256c3cb0317e"
    sha256 cellar: :any,                 arm64_sonoma:  "9a3a3ab017ce2028e3f45c5868789616655dc663b8b08e048ca3fb31c4e9229d"
    sha256 cellar: :any,                 sonoma:        "85257302b332ed2fb4cb1bc06494347e6948aea8f1b3f596c6c2f5749d224173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bd9161cb885806859a3e0eb9f9bb685f1e3c78ec98784dc171fdb9eb3dcf1e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6787d23093ad14ccd4411bebee8520fae2c42a6ba49dbeed600b09188c44b5da"
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