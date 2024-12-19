class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https:lld.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.6llvm-project-19.1.6.src.tar.xz"
  sha256 "e3f79317adaa9196d2cfffe1c869d7c100b7540832bc44fe0d3f44a12861fa34"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "95521797e73e9ab233faaf3ce0d111c0f7bc782a3a1f6a109fab26f1c719a478"
    sha256 cellar: :any,                 arm64_sonoma:  "14522a56f7112b1234f8233eaeb6127c26e977b98e0a225db5fafc5a9a920d3e"
    sha256 cellar: :any,                 arm64_ventura: "e71bb98b739c7d3f37d0e79dad146856090e625142a4ec15484750ef97219e14"
    sha256 cellar: :any,                 sonoma:        "dba5127406f830f649fb3ff415ae8c61c9e2754cf4bebc8b5fa165ac6dbc5472"
    sha256 cellar: :any,                 ventura:       "18156542d8218cfc5ac54406e16d03ab84c3833c9fae09b46a652b91aa65287f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f55d6d9c8e07af04ce74fe7f5d5675f26101ff4c4c673ea6dfc427d461d2b712"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "zstd"
  uses_from_macos "zlib"

  # These used to be part of LLVM.
  link_overwrite "binlld", "binld64.lld", "binld.lld", "binlld-link", "binwasm-ld"
  link_overwrite "includelld*", "libcmakelld*"

  def install
    system "cmake", "-S", "lld", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLLD_BUILT_STANDALONE=ON",
                    "-DLLD_VENDOR=#{tap&.user}",
                    "-DLLVM_ENABLE_LTO=ON",
                    "-DLLVM_INCLUDE_TESTS=OFF",
                    "-DLLVM_USE_SYMLINKS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"binlld").write <<~BASH
      #!binbash
      exit 1
    BASH
    chmod "+x", "binlld"

    (testpath"bin").install_symlink "lld" => "ld64.lld"
    (testpath"bin").install_symlink "lld" => "ld.lld"

    (testpath"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!");
        return 0;
      }
    C

    error_message = case ENV.compiler
    when ^gcc(-\d+)?$ then "ld returned 1 exit status"
    when :clang then "linker command failed"
    else odie "unexpected compiler"
    end

    # Check that the `-fuse-ld=lld` flag actually picks up LLD from PATH.
    with_env(PATH: "#{testpath}bin:#{ENV["PATH"]}") do
      assert_match error_message, shell_output("#{ENV.cc} -v -fuse-ld=lld test.c 2>&1", 1)
    end

    system ENV.cc, "-v", "-fuse-ld=lld", "test.c", "-o", "test"
    assert_match "hello, world!", shell_output(".test")
  end
end