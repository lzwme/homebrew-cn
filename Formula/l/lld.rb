class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.0/llvm-project-21.1.0.src.tar.xz"
  sha256 "1672e3efb4c2affd62dbbe12ea898b28a451416c7d95c1bd0190c26cbe878825"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d8741d107d61164c194cf5f26579bed4e7aeeab448ec45fe1b1f6882a77864a4"
    sha256 cellar: :any,                 arm64_sonoma:  "1ad1744b16d99758b4511e355e243327aa6dbc28cf284e6be673790b2e0a249d"
    sha256 cellar: :any,                 arm64_ventura: "45fb2d3f79ad7f7db4201c902af14002bf169a97bb77b31946b7a4c540052c31"
    sha256 cellar: :any,                 sonoma:        "f9708066a2c99887df9addadddb89b027214a1f39521b54df4333d9cb497f5d4"
    sha256 cellar: :any,                 ventura:       "8f485dc2f5210a4a32b0e5e7b15cb0936b45f7688867318e24ae3cd32edb9b49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14fc74d22edcdff422a49363ba938b742efcbe54a86cd4af11b5d2e1401aa745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ba7d1788190d6f1566b821e7d0df1d57acfa3ea2cb80ceba011c357daac0505"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "zstd"
  uses_from_macos "zlib"

  # These used to be part of LLVM.
  link_overwrite "bin/lld", "bin/ld64.lld", "bin/ld.lld", "bin/lld-link", "bin/wasm-ld"
  link_overwrite "include/lld/*", "lib/cmake/lld/*"

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
    (testpath/"bin/lld").write <<~BASH
      #!/bin/bash
      exit 1
    BASH
    chmod "+x", "bin/lld"

    (testpath/"bin").install_symlink "lld" => "ld64.lld"
    (testpath/"bin").install_symlink "lld" => "ld.lld"

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!");
        return 0;
      }
    C

    error_message = case ENV.compiler
    when /^gcc(-\d+)?$/ then "ld returned 1 exit status"
    when :clang then "linker command failed"
    else odie "unexpected compiler"
    end

    # Check that the `-fuse-ld=lld` flag actually picks up LLD from PATH.
    with_env(PATH: "#{testpath}/bin:#{ENV["PATH"]}") do
      assert_match error_message, shell_output("#{ENV.cc} -v -fuse-ld=lld test.c 2>&1", 1)
    end

    system ENV.cc, "-v", "-fuse-ld=lld", "test.c", "-o", "test"
    assert_match "hello, world!", shell_output("./test")
  end
end