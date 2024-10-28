class Verilator < Formula
  desc "Verilog simulator"
  homepage "https:www.veripool.orgwikiverilator"
  url "https:github.comverilatorverilatorarchiverefstagsv5.030.tar.gz"
  sha256 "b9e7e97257ca3825fcc75acbed792b03c3ec411d6808ad209d20917705407eac"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https:github.comverilatorverilator.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "89b842e26be55b8801f4c1acb4e8ff69832b41ab1275fe9af5ce2e2be2d7169f"
    sha256 arm64_sonoma:  "5891c341e03ec64f2fa05999d80391aa8f3f0873cdf73ed096821fd55718c553"
    sha256 arm64_ventura: "7ce77901dc02a1459a2e9526a30a0d4586ff2704ac1366ba9b5f12e4427de9e3"
    sha256 sonoma:        "aff2df390996f738267cce2450c75bc00e793d06a9b346423e0964a165c1c115"
    sha256 ventura:       "abd173206449d6d2d80971dc099acea2b6ab0efdd5e2805947b775d12808f472"
    sha256 x86_64_linux:  "5f911e440b3cbacf2732bedf833ae2ce7efb0f4e0577ab9f26f6fff0f843520b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "help2man" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl"
  uses_from_macos "python", since: :catalina

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  # error: specialization of 'template<class _Tp> struct std::hash' in different namespace
  fails_with gcc: "5"

  def install
    system "autoconf"
    system ".configure", "--prefix=#{prefix}"
    ENV.deparallelize if OS.mac?
    # `make` and `make install` need to be separate for parallel builds
    system "make"
    system "make", "install"

    # Avoid hardcoding build-time references that may not be valid at runtime.
    inreplace pkgshare"includeverilated.mk" do |s|
      s.change_make_var! "CXX", "c++"
      s.change_make_var! "LINK", "c++"
      s.change_make_var! "PERL", "perl"
      s.change_make_var! "PYTHON3", "python3"
    end
  end

  test do
    (testpath"test.v").write <<~EOS
      module test;
         initial begin $display("Hello World"); $finish; end
      endmodule
    EOS
    (testpath"test.cpp").write <<~EOS
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
    system bin"verilator", "-Wall", "--cc", "test.v", "--exe", "test.cpp"
    cd "obj_dir" do
      system "make", "-j", "-f", "Vtest.mk", "Vtest"
      expected = <<~EOS
        Hello World
        - test.v:2: Verilog $finish
      EOS
      assert_equal expected, shell_output(".Vtest")
    end
  end
end