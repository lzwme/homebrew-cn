class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "10.2.2",
      revision: "0d2d3c469dad4a046d91901f04f049c531234e7e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02462f56b6fd87ad30130a3243789b1c030c7fc27e63568242d13ac2de0fc28f"
    sha256 cellar: :any,                 arm64_sequoia: "c7a531274619a1590fe71ef10a7ff2a1bb5c4656d4d6d89260f68fcce984f0ed"
    sha256 cellar: :any,                 arm64_sonoma:  "d53291e651e1113d3db01fc44228072e63c80fda81ff083a33421ef1f1582d61"
    sha256 cellar: :any,                 sonoma:        "17f0a6bdab1e5f98d9d57e84a15e88e6933ad96c1b8063e0bf7525470eefc310"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a189a6b0bee1189cda7edf66b100d2a63a7b1cf3502e1872d308d3c47f08fa93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a9b382551a92d17123b18b81c96263db1ad27bc0ac1b12f24482332b6c06188"
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