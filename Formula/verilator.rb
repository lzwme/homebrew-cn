class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://ghproxy.com/https://github.com/verilator/verilator/archive/refs/tags/v5.012.tar.gz"
  sha256 "db19a7d7615b37d9108654e757427e4c3f44e6e973ed40dd5e0e80cc6beb8467"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "2f496ab92229af3b09566a1b898e673db247a5083a5ba53cec01d1a6af292b90"
    sha256 arm64_monterey: "0531a914f65009075a4bc2031180207002d4a037ec49787956104b6e7b8224bd"
    sha256 arm64_big_sur:  "1b3299485b2d421bc63347c14df16e64ae7f4131ce3fda68f523cf8e606209a4"
    sha256 ventura:        "8a8227fe81a012fbc753cbb56545542695bfe4496cd29be288106cfaeae514df"
    sha256 monterey:       "a5c7d0400be43694ed30963349bd38205f194defe7d6f43bb324999627b82d04"
    sha256 big_sur:        "452185cbbe92594b1ea5d1d53a660184e8d7c1dc78e80d50744f0f44fd9ac32f"
    sha256 x86_64_linux:   "d8e53c8300132547b8d241df51ae64af6146281f54971287f799b41274ddb4b5"
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
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize if OS.mac?
    # `make` and `make install` need to be separate for parallel builds
    system "make"
    system "make", "install"

    # Avoid hardcoding build-time references that may not be valid at runtime.
    inreplace pkgshare/"include/verilated.mk" do |s|
      s.change_make_var! "CXX", "c++"
      s.change_make_var! "LINK", "c++"
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