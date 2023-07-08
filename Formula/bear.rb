class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghproxy.com/https://github.com/rizsotto/Bear/archive/3.1.2.tar.gz"
  sha256 "5f94e98480bd8576a64cd1d59649f34b09b4e02a81f1d983c92af1113e061fc3"
  license "GPL-3.0-or-later"
  revision 6
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "59b8377c3111f09a516cc1cac6ad73240e3a0ca940d1206069f40930af3ef38a"
    sha256 arm64_monterey: "827d5d5bb17cfa7db5d5747eb32be9921038638c137818a78124bacd30641874"
    sha256 arm64_big_sur:  "9eb11c5e6633e2f92363f09204a84b605de3b6ed25786dfa54353214c088938f"
    sha256 ventura:        "2c876929401db289a2720cbc7fe8a7304168e3faf40925da5bee14e1ba12ae4e"
    sha256 monterey:       "d5e9fa3601e2d111d0a8d4f974ef57e159d991d3e4a10b1e60c5247c10af2939"
    sha256 big_sur:        "6be1d9b27d56a0a613c55590be74993d478384a2bf85b804a45d73d99c3a3201"
    sha256 x86_64_linux:   "1e91d9840c737152df6e6be5f857cfe130f5ecc24ab96cd0edaebd0fb521b04c"
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