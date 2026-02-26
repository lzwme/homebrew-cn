class LldAT21 < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-project-21.1.8.src.tar.xz"
  sha256 "4633a23617fa31a3ea51242586ea7fb1da7140e426bd62fc164261fe036aa142"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    formula "llvm@21"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "adbc47c9a735cd5c28c485a7bedbf9bef7af2652a6d89d1e8f78dab9367625c6"
    sha256 cellar: :any,                 arm64_sequoia: "12509c3c0027577824b6d98a5e4265c4016f6f311b47975cb4d39ae7373620bf"
    sha256 cellar: :any,                 arm64_sonoma:  "62db801951b3822a19dda273b12317654b03bfe56b9113f50cc4f69331a4ea06"
    sha256 cellar: :any,                 sonoma:        "15fa1536fec1ead5d2f4e29b3ccc947dcba8285277bc00a6f312986e147b4535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "020c5bb5b9a9d50f5aa1a38a6357f10b0d44f7ad4dc82f9fab3ae5c5fec54e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f28a6087b19e81177061fd9fe7dfb181216863e145731ebade85cfa37e9001bb"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm@21"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    rpaths = [rpath]
    rpaths << Formula["llvm@21"].opt_lib.to_s if OS.linux?

    system "cmake", "-S", "lld", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
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
    (testpath/"bin/lld").write <<~SHELL
      #!/bin/bash
      exit 1
    SHELL
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
    ENV.prepend_path "PATH", bin
    with_env(PATH: "#{testpath}/bin:#{ENV["PATH"]}") do
      assert_match error_message, shell_output("#{ENV.cc} -v -fuse-ld=lld test.c 2>&1", 1)
    end

    system ENV.cc, "-v", "-fuse-ld=lld", "test.c", "-o", "test"
    assert_match "hello, world!", shell_output("./test")
  end
end