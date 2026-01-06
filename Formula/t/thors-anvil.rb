class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "8.0.15",
      revision: "d16e8bca49445e95bcdd9eec089e0e8c6c48d108"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9cf06d327a5384bcbf66ca6bce8b720151a60c08c0395fb3093adaa6ef831e4b"
    sha256 cellar: :any,                 arm64_sequoia: "82348b44564e3a7e1090c395b49a02fe30a04cb6f495c8fef50324fb56d7987d"
    sha256 cellar: :any,                 arm64_sonoma:  "2ae07950dd22c4cfc4645e8785f94edbf0dd64a0ef2a604f7ffb107d1bd6ad2d"
    sha256 cellar: :any,                 sonoma:        "15ca999f641599ee5445aeac537b62da47282b6264b6ea6b496b76e130022702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "633c2368881f041ff7fe7b217b8b3837c6ccb5af61f6465b2604780271834c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aecb1a2f4d75fc719a0d4a1ed71857631bdeb474705186800144b4e615ebd123"
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