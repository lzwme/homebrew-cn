class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "8.0.04",
      revision: "f7bf4c45fa33d7fb4bf924d424d29a537ec56b01"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4cd153e8c806c960a028af98f16aac3b98a399f33ca4ce257182f9d94bad5f92"
    sha256 cellar: :any,                 arm64_sequoia: "0d78a2c2bc758cef78e5231ca7cdcfa40029526f0aa65fe3d4856fd919a61727"
    sha256 cellar: :any,                 arm64_sonoma:  "c4f90e9403812f492424a157d415bb0aa7971773b243dd36c3d3716ae5baff95"
    sha256 cellar: :any,                 sonoma:        "49014165cc31b49028797812625303fd8e846c1fec0816c66fc861cba8b9cad3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "611f80abdf2a31d991e4c816294d37ebed07131e2dd7d3829415c1acaf0fd4e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3b48bbe8478d55dda9395e9e7ee1e7f41efd8aab46bf3adf86adfaa2fd6827d"
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