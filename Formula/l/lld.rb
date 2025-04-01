class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https:lld.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.1llvm-project-20.1.1.src.tar.xz"
  sha256 "4d5ebbd40ce1e984a650818a4bb5ae86fc70644dec2e6d54e78b4176db3332e0"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74cf6d98e4a3cb4a2dc75dc62bbc8824928e5d7ae5d7362752b1aad36f30c4d7"
    sha256 cellar: :any,                 arm64_sonoma:  "fdfd7ed2bb4c3b7441c1267cebcd8aad501ac21f49e80806f03824907ba7578c"
    sha256 cellar: :any,                 arm64_ventura: "36dc0f48d3da51fc6de6382aa189b0adb2a19ea7e0965bca5e5db633840e16f5"
    sha256 cellar: :any,                 sonoma:        "822bb2e2da86007d332619a69d9d7b8de2738cdfdee5759406c8b978867e1ba1"
    sha256 cellar: :any,                 ventura:       "091c45aa9750974817e036af9c52fab079066b619f7442c332594ad3a1e06e21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd1e8a417f657d31052cf7272f2133f602edcf47342fbd80961349f470e6ce12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aadf2d12b3382d291a52f5e4938fd2c691433d31e12886dfe27d61a0cebbd7d3"
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