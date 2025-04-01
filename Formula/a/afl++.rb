class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https:aflplus.plus"
  url "https:github.comAFLplusplusAFLplusplusarchiverefstagsv4.31c.tar.gz"
  sha256 "8c6e9bef19b3d43020972701553734d1cb435c39a28b253f0dd6668e6ecb86bb"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)c$i)
  end

  bottle do
    sha256 arm64_sequoia: "7a378b0e8a1d60016d6ae67e686bb0e6b8f655b9b6c8d593168c5d7545b8fa83"
    sha256 arm64_sonoma:  "f0bc5e03c502cc886e139c3d8c14e7ed6ba4e092423147738865f0b11cc4292a"
    sha256 arm64_ventura: "97adccf108606e756e67910113f19518512ffefd2e7302618f91f2545308890a"
    sha256 sonoma:        "daf444540b9b7e93cd6fef887b5dd6a67990a3a46529d6da9f3d135af02f0061"
    sha256 ventura:       "faa89dc2fbfd7ceef19a86f8347abb1ab794382b57942234ae874b855f9532cb"
    sha256 arm64_linux:   "ce2a30d50efac60aaf533b0d3b5e79bead6028591e082ce3dd428e53b355b551"
    sha256 x86_64_linux:  "9a2bd9c0d0fb82231ed843c3c3f6a987d56612dc9f8e728f40565c1c9cbb2631"
  end

  depends_on "coreutils" => :build
  depends_on "llvm"
  depends_on "python@3.13"

  uses_from_macos "zlib"

  # The Makefile will insist on compiling with LLVM clang even without this.
  fails_with :clang
  fails_with :gcc

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec"gnubin"

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
    cpp_file.write <<~CPP
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    CPP

    system bin"afl-c++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output(".test")
  end
end