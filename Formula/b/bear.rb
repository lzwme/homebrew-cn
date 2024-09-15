class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  license "GPL-3.0-or-later"
  revision 8
  head "https:github.comrizsottoBear.git", branch: "master"

  stable do
    url "https:github.comrizsottoBeararchiverefstags3.1.4.tar.gz"
    sha256 "a1105023795b3e1b9abc29c088cdec5464cc9f3b640b5078dc90a505498da5ff"

    # fmt 11 compatibility
    patch do
      url "https:github.comrizsottoBearcommit8afeafe61299c87449023d63336389f159b55808.patch?full_index=1"
      sha256 "40d273a1f1497c2e593fc657a0cdf45831da308c00e3425e5eddb790afceb45f"
    end
  end

  bottle do
    sha256 arm64_sequoia: "8e05e2846e3e73fb303b0f830e0f3b1e12fc5a6fee38db9704db80884f1de629"
    sha256 arm64_sonoma:  "93d5a521be30785a71418435be63563cfd9b4367e647b86defa65dfe4ab98c67"
    sha256 arm64_ventura: "ff56f51692f83e132b8325fa2692076d910687301b2bc6567f6a6dfe01fd039a"
    sha256 sonoma:        "ef5218b91e136a905fc0e90327c16ab4c88e46042b96e9d6726a812eb1da44a1"
    sha256 ventura:       "2fec1159f7dbcc7ba2b0e9b190d90e2e2646d5eff35b39521a95a03e6ce56cf5"
    sha256 x86_64_linux:  "e8b5e228916688d811ddc8a2df803f36abf23e431a8a48cb1819293a9503c805"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "protobuf"
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
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin"bear", "--", "clang", "test.c"
    assert_predicate testpath"compile_commands.json", :exist?
  end
end