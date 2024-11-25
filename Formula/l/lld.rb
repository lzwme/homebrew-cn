class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https:lld.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.4llvm-project-19.1.4.src.tar.xz"
  sha256 "3aa2d2d2c7553164ad5c6f3b932b31816e422635e18620c9349a7da95b98d811"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ebcb94cf6a0bb11d36c1d9ad02cba32fec27d13d025f8a6c6f47005c0c48943"
    sha256 cellar: :any,                 arm64_sonoma:  "ddb0acc8f9de10d260ebd4462f39d81fa4280898035505fe3afb8a02fa11fb58"
    sha256 cellar: :any,                 arm64_ventura: "1b8a4a36ccf53a55a7c2a528fc388f45753426d54520a95200eca0b432cd74f2"
    sha256 cellar: :any,                 sonoma:        "7cdf30a0ab84883b2994e0995c78d6f2cd8b7bee50b32d1aab86c6bfa84d0bbf"
    sha256 cellar: :any,                 ventura:       "e9412b4eaaf2c5a86f97d806d13bd88546514fe5d66bf20fb01cc6ca7faea4a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe1924ca8a6b1c0fbf60a166c5c7a1b34ef27baf6147a42c3262428c3b72b11"
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