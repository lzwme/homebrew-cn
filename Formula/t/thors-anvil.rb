class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "10.1.1",
      revision: "073c62d5082ee755993b3ceb9040151094091de1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a8ea97875ea6416f456e3a2b13eb07e97e5a957260d9206f3514dad0e725629"
    sha256 cellar: :any,                 arm64_sequoia: "75adcec00f7e646ab615863bd98510586b690dd3d103e8b71de69460d0b777ba"
    sha256 cellar: :any,                 arm64_sonoma:  "571e600376a7d7115ad68c5b7ab09b2d5c5d39a9cfd509aeb721d95fee7c7400"
    sha256 cellar: :any,                 sonoma:        "b6230d8dbcbe0de4cecf4733f11ed21bcf1d1ae15ea9e911f04d9c9f62c3079c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4de984031619969acb0e2469a7c0755ccf55cfdc017a25c5d15508cda438080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58c4f9c2a0fe31f6a9bde1e961ffb8b4cdde0d3cb661c5eac1bd76a87067d61f"
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