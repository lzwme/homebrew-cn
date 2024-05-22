class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "https://gitlab.com/iniparser/iniparser"
  url "https://gitlab.com/iniparser/iniparser/-/archive/v4.2.2/iniparser-v4.2.2.tar.bz2"
  sha256 "2e0e448377c5ff69f809160824a7af60846ddf6055d19a96c269b9682aea761e"
  license "MIT"
  head "https://gitlab.com/iniparser/iniparser.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ff19dc079e7b301b1ecf4fe793f71e24d4f3c62453ab75c5de958a03d1acdc30"
    sha256 cellar: :any,                 arm64_ventura:  "dcae85da4cdd7827d6ebcfbddd005a5e1839b3944fafb0a2aaf25f8e35f78774"
    sha256 cellar: :any,                 arm64_monterey: "0c3040ee4f3a1cd894fd2893642e2326f623c5b3148c5fce1db4a8636b3083d6"
    sha256 cellar: :any,                 sonoma:         "78373947428f27fe156a8fb965fca7dbf959cfe73f3a44c51bd1256536f4a7a0"
    sha256 cellar: :any,                 ventura:        "7de2d005b9b01c0cf9dc1897f4f4e326a4ceb62a0ac691487452e5e81ed7af94"
    sha256 cellar: :any,                 monterey:       "208d502f8c397c5ddc6b1f2dec3b54fc03957ae94216c9eafc7bd204f331339a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "899186db0aa1a8860f8e188a3526bccbf076c183b78c3360d4528fba43e3ff70"
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