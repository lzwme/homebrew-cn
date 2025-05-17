class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https:lld.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.5llvm-project-20.1.5.src.tar.xz"
  sha256 "a069565cd1c6aee48ee0f36de300635b5781f355d7b3c96a28062d50d575fa3e"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fedbf975ebd0c2fd5ae881ec0933a27e4e454bc815f8945a1b762ba5635e2f90"
    sha256 cellar: :any,                 arm64_sonoma:  "ad1c57e5c676c602f3237009015bbc2dde283383fa155ebeccc753498580e853"
    sha256 cellar: :any,                 arm64_ventura: "c32c92624d5b76a5b3ed58461c69b5a3acf99045fce95bbabed4dd587bf60de7"
    sha256 cellar: :any,                 sonoma:        "3d7d13c65b4c1f04a6af8f198a172c348d0c43d11162f7210aaa25e16c9892d5"
    sha256 cellar: :any,                 ventura:       "411fa414a7fb79b47b5a881dc1f8910c8857fa70696fb51f66685dd842aae061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a19135c3e23f345421ee614701a38a57d8a57b15f3f7756e60ec0c020e7af328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b654a588a1873f6d444ecbbcf1ce526f286fc268cc10928288d14df70b3494ca"
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