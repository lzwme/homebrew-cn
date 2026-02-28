class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.0/llvm-project-22.1.0.src.tar.xz"
  sha256 "25d2e2adc4356d758405dd885fcfd6447bce82a90eb78b6b87ce0934bd077173"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49565c7e4d982be4966f463ce52546149c90c8d5a62d13999934d9c4a4e821dd"
    sha256 cellar: :any,                 arm64_sequoia: "5e68faa8c606e5ece080b7f5a36643b345c2a8eb4a606b0ae5bb4fdfd6ee1798"
    sha256 cellar: :any,                 arm64_sonoma:  "ca5593f907c479971209a7e7187a89083199a2a63149cdc3fdf0d3e4a680c550"
    sha256 cellar: :any,                 sonoma:        "c6301b7e626d8aa24bddcc666783c626dcd27d0cace4ff156f777fe66128b40f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e14e53340d90a11af6c8620fc4682b16e87934e3050fc6cbbfd5c00f1833f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "811ee6904c5c5aa95070e3df114ab4a64da348652e5cd3f5474c796d8ecee237"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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