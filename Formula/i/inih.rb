class Inih < Formula
  desc "Simple .INI file parser in C"
  homepage "https:github.combenhoytinih"
  url "https:github.combenhoytiniharchiverefstagsr59.tar.gz"
  sha256 "062279922805f5e9a369551a08d5ddb506140fe50774183ffdbb7c22bb97e3f4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12a5f9231059f1e683796f68eb0b6f3df1459d710bc6dfbb4b7fac52f8f0e97a"
    sha256 cellar: :any,                 arm64_sonoma:  "b3b94f4ff780ed221ce37ab8606c301dc9f15d9006b151edde823b4e8bb247ae"
    sha256 cellar: :any,                 arm64_ventura: "9c0385fb6a8ac03598803d2a50a842238c050607239a30ce9fdd8b94fc9cd34d"
    sha256 cellar: :any,                 sonoma:        "2a3772b9202962b26ef97b642af2366e253367e4cd2ac25b87bed972cb008157"
    sha256 cellar: :any,                 ventura:       "f8c086f3e0109561f3925bdeee1405d41f0dd194e10ed5b151394afe2c0984db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8c5f62b2fa13028915bb5601c01b2d58a1c66eb10241b38b09e26046ca8ee9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda073c8c1003062c75c2e3b46c4b2d490bf53f92e3dfc9ae091803cfce2b192"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "-Dcpp_std=c++11", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include <ini.h>

      static int dumper(void* user, const char* section, const char* name, const char* value) {
          static char prev_section[50] = "";
          if (strcmp(section, prev_section)) {
              printf("%s[%s]\\n", (prev_section[0] ? "\\n" : ""), section);
              strncpy(prev_section, section, sizeof(prev_section));
              prev_section[sizeof(prev_section) - 1] = '\\0';
          }
          printf("%s = %s\\n", name, value);
          return 1;
      }

      int main(int argc, char* argv[]) {
          if (argc <= 1) {
              return 1;
          }

          int error = ini_parse(argv[1], dumper, NULL);
          if (error < 0) {
              printf("Can't read '%s'!\\n", argv[1]);
              return 2;
          } else if (error) {
              printf("Bad config file (first error on line %d)!\\n", error);
              return 3;
          }
          return 0;
      }
    C

    (testpath"test.ini").write <<~EOS
      [protocol]             ; Protocol configuration
      version=6              ; IPv6

      [user]
      name = Bob Smith       ; Spaces around '=' are stripped
      email = bob@smith.com  ; And comments (like this) ignored
      active = true          ; Test a boolean
      pi = 3.14159           ; Test a floating point number
    EOS

    expected = <<~EOS
      [protocol]
      version = 6

      [user]
      name = Bob Smith
      email = bob@smith.com
      active = true
      pi = 3.14159
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-linih", "-o", "test"
    assert_equal expected, shell_output(".test test.ini")
  end
end