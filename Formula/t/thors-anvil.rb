class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "10.0.6",
      revision: "5721502233a1f3f54a0efeb1fd957d889e368a7d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a9aaa672ceeed06a3022283ae86fc814872987283b4896d1103dd42256dd88a"
    sha256 cellar: :any,                 arm64_sequoia: "1d0a92570e6767b58549a7c0c2e31a26d1b1207be092f438a53cbb8ffe8cbbbe"
    sha256 cellar: :any,                 arm64_sonoma:  "01e895802ea956db6321a4beeb359beba95656ef6abeb90377341127bb3af1b5"
    sha256 cellar: :any,                 sonoma:        "30583b99da787a5f9b801ebba3b289f104ad595455f6cf3bf03f29aa409328c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "305d2a32a899bb1bb13a3717478abf654659ba48da8fffeffcf3caab09171537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cc42fd3f6050027ceb42ab16943d09324a49db9a15aa9264c422d3bc69c2bdb"
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