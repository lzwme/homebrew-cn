class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghproxy.com/https://github.com/rizsotto/Bear/archive/3.1.2.tar.gz"
  sha256 "5f94e98480bd8576a64cd1d59649f34b09b4e02a81f1d983c92af1113e061fc3"
  license "GPL-3.0-or-later"
  revision 8
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "de24837278d844b667ccdad3efb38e3004064549c58a8cd40fac4aa5522fcb65"
    sha256 arm64_monterey: "fee200d29359732114e9fd115d3f5f3211fbcba708c0929d73bfeaab70791f30"
    sha256 arm64_big_sur:  "b72f7c81a7bef584efe90196245078f0e0c5e235fc02d4635e17de5a01c4c8c1"
    sha256 ventura:        "ecc17cb9ccc86953ef8d1091df2591c219d5f51e3b39d341f24bbd2561c741e9"
    sha256 monterey:       "da796509abf3875aae9eaa28db7954c108ff51cbeb2a3d2ab8a6d2d20bdec509"
    sha256 big_sur:        "ffef1938aa287b15ff802f05f3e457cfdead8aa12c169b4ff040de99aec54684"
    sha256 x86_64_linux:   "f17cc600fe96a850bf06560bc0813f3e9c0a6a40322baff2104fcc1ae33da521"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__current_path(std::__1::error_code*)"
    EOS
  end

  # Add support for fmt 10
  patch do
    url "https://github.com/rizsotto/Bear/commit/46a032fa0fc8131779ece13f26735ec84be891e8.patch?full_index=1"
    sha256 "af2a1bb3feb008f2ed354c6409b734f570a89caf8bcc860d9ccf02ebe611d167"
  end

  # Add support for fmt 10.1 https://github.com/rizsotto/Bear/pull/543
  patch do
    url "https://github.com/rizsotto/Bear/commit/00636df012c251a99157e76401f0d595efef85fc.patch?full_index=1"
    sha256 "f0b003aef6c2ad04086dad064ff5af6d0745b1353c8e0ff19a75a3e812969568"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end