class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https:lld.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.7llvm-project-20.1.7.src.tar.xz"
  sha256 "cd8fd55d97ad3e360b1d5aaf98388d1f70dfffb7df36beee478be3b839ff9008"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a20960b42ac4355958720e5f031f0abdeca7c83bc8fe45fc1e70aae8e3059dc5"
    sha256 cellar: :any,                 arm64_sonoma:  "e4870d62b231afdd6bd421369ad47b6c13ca6e7afca5e411a1374eb957f6c5f0"
    sha256 cellar: :any,                 arm64_ventura: "57aa0a4ca2c57d0150936e824c6c6029b807bb02d3d8e72562eea1b5c6955c6e"
    sha256 cellar: :any,                 sonoma:        "68109af50e6d5c69501eaab32ec88094d5664d6d1c808637c56922b8f3c29f16"
    sha256 cellar: :any,                 ventura:       "95cb39802f0325dafb8dcae9aee6de8ce3dab316a004c00c511f92a6811ec232"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d43d5492df63ef62930ede74732b634d46f64c943b347295ccd238cbc909e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d11a203f4c24c67ddbed7098816499855ffcbc59a36ab6cb9bfd19a55537f1"
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