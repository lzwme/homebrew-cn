class Inih < Formula
  desc "Simple .INI file parser in C"
  homepage "https://github.com/benhoyt/inih"
  url "https://ghfast.top/https://github.com/benhoyt/inih/archive/refs/tags/r61.tar.gz"
  sha256 "7caf26a2202a4ca689df3fe4175dfa74e0faa18fcca07331bba934fd0ecb8f12"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed62e58a82c126b276b22d91201c3cb4c0217e3688c6c3da6f01dd5f4a060dd2"
    sha256 cellar: :any,                 arm64_sonoma:  "b8ac719b2817551d40288947bfb423754d82ab50cc661529190a4ea4a0839bfb"
    sha256 cellar: :any,                 arm64_ventura: "01ec5073d4a3c4d63a62c066bdb98e97a85d7adee1610bc6c2c582d534b35410"
    sha256 cellar: :any,                 sonoma:        "5f46d2699534d1b5edb4d7f0951bcd0d24d3bb438b2bb377a6bbb5dea0a5bc27"
    sha256 cellar: :any,                 ventura:       "2a06a5a7cad91350039eec427993978b8b8553a0a11087bac54e7fdaf91d20a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50189e833fba0109b74c7ce108e4336218daa04a839137cedecf29154e614367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e708f655cfee618ba6b14ca3d45994ac0384675ba4e05b0c6f0e0d8513cb2d9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "-Dcpp_std=c++11", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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

    (testpath/"test.ini").write <<~EOS
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
    assert_equal expected, shell_output("./test test.ini")
  end
end