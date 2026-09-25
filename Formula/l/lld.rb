class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.2/llvm-project-23.1.2.src.tar.xz"
  sha256 "c98bbef08a2b4c2613cd50e9aa9ae7b69b1fe6c16b2c40373bc0ab6116fdf78a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 2
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bb37bcd474a36445799045cb1952a0b3423473263167d2ef585837a2f768be9a"
    sha256 cellar: :any, arm64_tahoe:       "5c07c0bc0d03ef6789bc268941331db88087bdcd76b5c7814e3ce10be040695a"
    sha256 cellar: :any, arm64_sequoia:     "0a7466c8d49c0cdf8120d0eb039ffe6a09a81b919bc4d318ebacfb8871cf64e1"
    sha256 cellar: :any, arm64_linux:       "cfbfc931bdc1d2c0f13b9054d65e648797dfb2d7323445a23b9634ca5d32409e"
    sha256 cellar: :any, x86_64_linux:      "4209f529d402ec0fb7c7ef76713f70e58997280164e8a994192efffef3e86e71"
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
                    "-DLLD_VENDOR=#{tap&.user}",
                    "-DLLVM_ENABLE_LTO=ON",
                    "-DLLVM_INCLUDE_TESTS=OFF",
                    "-DLLVM_USE_SYMLINKS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    man1.install Utils::Gzip.compress("lld/docs/ld.lld.1")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/wasm-ld --version")

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