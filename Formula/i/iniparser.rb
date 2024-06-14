class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "https://gitlab.com/iniparser/iniparser"
  url "https://gitlab.com/iniparser/iniparser/-/archive/v4.2.3/iniparser-v4.2.3.tar.bz2"
  sha256 "cf9afba93f524e04483a6438698de8d6b4b4a3c817c2f2ca5df46919b47c8b75"
  license "MIT"
  head "https://gitlab.com/iniparser/iniparser.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df7cd6b03bd305992437bb5a7b6a7822126e406cba0a4602e7b773b5477de850"
    sha256 cellar: :any,                 arm64_ventura:  "b215b6778fac7a7f2550809bc82c8a7afb5922f7f058aa613686ec582db18b1f"
    sha256 cellar: :any,                 arm64_monterey: "feadfcbe2a6972acf894ce99cc3cad8119405678adcab92f1de2f77a3ad9f62c"
    sha256 cellar: :any,                 sonoma:         "92a5eaf12ad873442a1fde9478e552d7d9ed341c7f9f81687c02a49c0b42520e"
    sha256 cellar: :any,                 ventura:        "0414af8a5e511e4abc60d47ba6b8714f41da0c3ffa33bda2d589d4c4457b3626"
    sha256 cellar: :any,                 monterey:       "b42380cc658b2b7fdbfbb3970c1f05b453a5e68a941691fb52f0ea5d5c09946e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ceb11fd26232228421bec9b565f2f3d5e0d67524f521c8fb6c06138f702f3f0"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  conflicts_with "fastbit", because: "both install `include/dictionary.h`"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    test_config = testpath/"test.ini"
    test_config.write <<~EOS
      [section]
      key = value
    EOS

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      #include <iniparser/iniparser.h>

      int main() {
        dictionary *ini;
        ini = iniparser_load("#{test_config}");
        const char *value = iniparser_getstring(ini, "section:key", NULL);
        if (value == NULL || strcmp(value, "value") != 0) {
          fprintf(stderr, "value not found or incorrect\\n");
          return 1;
        }
        printf("Parsed value: %s", value);
        iniparser_freedict(ini);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-liniparser"
    assert_equal "Parsed value: value", shell_output("./test")
  end
end