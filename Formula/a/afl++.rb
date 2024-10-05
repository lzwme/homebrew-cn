class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https:aflplus.plus"
  url "https:github.comAFLplusplusAFLplusplusarchiverefstagsv4.21c.tar.gz"
  sha256 "11f7c77d37cff6e7f65ac7cc55bab7901e0c6208e845a38764394d04ed567b30"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_sequoia: "2d620933992908d3493f17b4e44c9f388e560c61ea07f5eeeaba6f06958c2981"
    sha256 arm64_sonoma:  "a91b21cfbebbbf85e072a2b564391e9abe6dacd23ae846d779a274f54c5d56a0"
    sha256 arm64_ventura: "af51fb3aacb8fc34e83c0d5473bcce88bcfcd5bee97a7d200df6b330573b1e74"
    sha256 sonoma:        "9972f30928d25849cf62eec6af83b4598e4cd38e34a465af4b871ee8cfac443f"
    sha256 ventura:       "3ecd8dae6fd187a902ac7e448e5f180440fc0a392ceb84569bc67a4dc3c498db"
    sha256 x86_64_linux:  "d405240caa4d8bd5c3f2d912da1aa755134d450f87c05929560356692354cedb"
  end

  depends_on "coreutils" => :build
  depends_on "llvm"
  depends_on "python@3.12"

  # The Makefile will insist on compiling with LLVM clang even without this.
  fails_with :clang
  fails_with :gcc

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec"gnubin"

    inreplace "GNUmakefile.llvm" do |s|
      s.gsub! "-Wl,-flat_namespace", ""
      s.gsub! "-undefined,suppress", "-undefined,dynamic_lookup"
    end

    if OS.mac?
      # Disable the in-build test runs as they require modifying system settings as root.
      inreplace ["GNUmakefile", "GNUmakefile.llvm"] do |f|
        f.gsub! "all_done: test_build", "all_done:"
        f.gsub! " test_build all_done", " all_done"
      end
    end

    llvm = Formula["llvm"]
    make_args = %W[
      PREFIX=#{prefix}
      CC=clang
      CXX=clang++
      LLVM_BINDIR=#{llvm.opt_bin}
      LLVM_LIBDIR=#{llvm.opt_lib}
    ]

    system "make", "source-only", *make_args
    system "make", "install", *make_args
    return unless llvm.keg_only?

    bin.env_script_all_files libexec, PATH: "#{llvm.opt_bin}:${PATH}"
  end

  test do
    cpp_file = testpath"main.cpp"
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin"afl-c++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output(".test")
  end
end