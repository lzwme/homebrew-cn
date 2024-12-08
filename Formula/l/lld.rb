class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https:lld.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.5llvm-project-19.1.5.src.tar.xz"
  sha256 "bd8445f554aae33d50d3212a15e993a667c0ad1b694ac1977f3463db3338e542"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9e2201ea66da84a61f99c65cfe6ffe792b12912c40b7d4bfb8f83683e9743abb"
    sha256 cellar: :any,                 arm64_sonoma:  "57f10f3e395087407f6ac6b55a21f63fc6527c4c1354f1136322a36571b3e552"
    sha256 cellar: :any,                 arm64_ventura: "3106367d9cfb99cb21b577e3bc1f89ec9afcfa14aa35f2bcbef075feb9476192"
    sha256 cellar: :any,                 sonoma:        "8a78f8c8a999e74cc430ff9311d8ac3a3f87f2b389b6245620fee5d8498410cc"
    sha256 cellar: :any,                 ventura:       "1c9044a605c0329f259571efb7921be2b51cb99a0d28aee04943d893095e1709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0026468b5517a18f150ded201ef028141b40a6713d2b2b36bcde35ee532bac3e"
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