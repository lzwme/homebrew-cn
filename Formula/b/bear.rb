class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  license "GPL-3.0-or-later"
  revision 7
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
    sha256 arm64_sequoia:  "d5ee1857d72a3047fc59eaaf41f4ad53512744f653122acc9f9e5730d3895b7d"
    sha256 arm64_sonoma:   "8e0fbb22f81b12cff11c83225b2ec261892ac168e2e815b0f1ffea58a9f64398"
    sha256 arm64_ventura:  "0106fd9b9b5aa8f138bb5142a2111fea1c95c902b3a5921f6618ade5a058c2c7"
    sha256 arm64_monterey: "301d12ffc7e9709caeec3a60576e889f6a11f7f27ad9465c5e111b8b7e2f8c1b"
    sha256 sonoma:         "f7e5bb2edf84eabd773ff81373a5dbd26ca7a640d75ebac1619af88e3de9a4a8"
    sha256 ventura:        "21bc8de2a76ed96b28746d0bd9fb672ce358cb88f11ce3270779dfc186d0d576"
    sha256 monterey:       "449a560f005e382d9fcbb60d1f69918e1a3f2b8f8bab4268863243514c9392dd"
    sha256 x86_64_linux:   "c2fcdc3a919ba9d3f07448d8eff61b0c1460a5f9ee6f507fb8efb8cea2ba728f"
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