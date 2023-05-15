class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghproxy.com/https://github.com/rizsotto/Bear/archive/3.1.2.tar.gz"
  sha256 "5f94e98480bd8576a64cd1d59649f34b09b4e02a81f1d983c92af1113e061fc3"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "7d467aaad8059181fb1577f6ff60f09e485db92cc7233d2833f6f8505e8a804f"
    sha256 arm64_monterey: "3ac2dace7a0f814073d80a8791b411eb4972cf428a8c454e754478500a7dbe34"
    sha256 arm64_big_sur:  "be260903f565160a3be5cf00311f9b88a91d2eb1ed52927d71feacbd74050153"
    sha256 ventura:        "6f72312856e474d8fde2e8b74066ff5b06922ae0037f281a2f7c98cd16e85b57"
    sha256 monterey:       "b4074974765d5f134069584e04927ff116ed4d45c05c88c9fead808f0f553e82"
    sha256 big_sur:        "652c8625d6082f1b2c728e1de893b19d0680dc446c9889ce3de42e685eaf86c0"
    sha256 x86_64_linux:   "5df3149933bbaa0f08f1cd987ef2aacfd1eadf2ff97579c3ce2d6e2628528e31"
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