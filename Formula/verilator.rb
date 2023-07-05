class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://ghproxy.com/https://github.com/verilator/verilator/archive/refs/tags/v5.012.tar.gz"
  sha256 "db19a7d7615b37d9108654e757427e4c3f44e6e973ed40dd5e0e80cc6beb8467"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "723416820e193fab7b74b6155b5b3d20adb67ba4c0fb7bdeec703a8a7164ecfa"
    sha256 arm64_monterey: "d6ed9db4e932076ec7edb374eda63191218d9881445a2723f53ccbff80ccd9b5"
    sha256 arm64_big_sur:  "ccc95f5e6ad07a077752dc2721ff0a1b83ade2f18104e7f39fb6cca46837864e"
    sha256 ventura:        "1f58ca9f455ae488d9e02b8439fc4679bf17382cfd14f03d65c3412c2adb3984"
    sha256 monterey:       "68d360b9b73fff9c5565e122543e3c3cfe6d2e3ddded0640329d438359eade39"
    sha256 big_sur:        "414a8f3d3f88dadee0db7751b1a15eca5aa56051713061838dfcee06cb7d2b53"
    sha256 x86_64_linux:   "60b18b8a552dc240cde3f1ffaeafdbbff864b8ec3cf67af319ff88eb7d2d0971"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "help2man" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl"
  uses_from_macos "python", since: :catalina

  on_macos do
    depends_on "gcc"
  end

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  # error: specialization of 'template<class _Tp> struct std::hash' in different namespace
  fails_with gcc: "5"

  # Build hangs when using Clang
  # https://github.com/Homebrew/homebrew-core/pull/124827
  # https://github.com/Homebrew/homebrew-core/pull/130893
  # https://github.com/Homebrew/homebrew-core/pull/133912
  fails_with :clang

  def install
    # V3Lexer_pregen.yy.cpp:369:10: fatal error: FlexLexer.h: No such file or directory
    ENV.append_to_cflags "-isystem /Library/Developer/CommandLineTools/usr/include" if OS.mac?

    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    # `make` and `make install` need to be separate for parallel builds
    system "make"
    system "make", "install"

    # Avoid hardcoding build-time references that may not be valid at runtime.
    gcc = Formula["gcc"]
    cxx = OS.mac? ? gcc.opt_bin/"g++-#{gcc.any_installed_version.major}" : "c++"
    inreplace pkgshare/"include/verilated.mk" do |s|
      s.change_make_var! "CXX", cxx
      s.change_make_var! "LINK", cxx
      s.change_make_var! "PERL", "perl"
      s.change_make_var! "PYTHON3", "python3"
    end
  end

  test do
    (testpath/"test.v").write <<~EOS
      module test;
         initial begin $display("Hello World"); $finish; end
      endmodule
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "Vtest.h"
      #include "verilated.h"
      int main(int argc, char **argv, char **env) {
          Verilated::commandArgs(argc, argv);
          Vtest* top = new Vtest;
          while (!Verilated::gotFinish()) { top->eval(); }
          delete top;
          exit(0);
      }
    EOS
    system bin/"verilator", "-Wall", "--cc", "test.v", "--exe", "test.cpp"
    cd "obj_dir" do
      system "make", "-j", "-f", "Vtest.mk", "Vtest"
      expected = <<~EOS
        Hello World
        - test.v:2: Verilog $finish
      EOS
      assert_equal expected, shell_output("./Vtest")
    end
  end
end