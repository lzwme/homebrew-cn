class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.2.20",
      revision: "d854cfdfbe269f1c5cb2f3266ac908e4fbd7fec3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6215f6fa21cbbef6b97c88ad9a51cff05c2123bfe9d18e57a2aec05541c874f6"
    sha256 cellar: :any,                 arm64_monterey: "9cfd635e0bb0f54e1df8a24629c512a3725322545d0dcafff73843135e6f0fe3"
    sha256 cellar: :any,                 arm64_big_sur:  "93385c1dc3aac36cf9086e2933ca1f9341710695f702b46cb0eb5a181c0d7472"
    sha256 cellar: :any,                 ventura:        "8e95ac5e165adf3f858c90ed3496348981eb0127525cabdca1e7a3eeafb0e536"
    sha256 cellar: :any,                 monterey:       "26d7d381662ba896e3027bace17f439a7411dd005878bc1d92d3ca07e28ab241"
    sha256 cellar: :any,                 big_sur:        "e2576fa606086b961c54f3cc494de09e1de7c85f921114b9e6072b03e406676b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ea74e5a8d9e045fb1be4194cdd7855e26ba252508957fbeb0d1f43e2e875489"
  end

  depends_on "boost" => :build
  depends_on "bzip2"
  depends_on "libyaml"
  depends_on "magic_enum"

  fails_with gcc: "5"

  def install
    ENV["COV"] = "gcov"

    system "./configure", "--disable-vera",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
           "-I#{Formula["boost"].opt_include}",
           "-I#{include}", "-L#{lib}", "-lThorSerialize17", "-lThorsLogging17", "-ldl"
    system "./test"
  end
end