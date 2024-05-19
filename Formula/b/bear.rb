class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.4.tar.gz"
  sha256 "a1105023795b3e1b9abc29c088cdec5464cc9f3b640b5078dc90a505498da5ff"
  license "GPL-3.0-or-later"
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "0e33e11634cd8168e661145c647cba54b7bd7e9ad716045717a6a7de347fbb3b"
    sha256 arm64_ventura:  "b58bed910bf894e95072cde7dd297e0999dbddb141ade63df00c8382ffc78dc3"
    sha256 arm64_monterey: "9cb6b3b13856d7012b367b022761f220484c4d9ec4e7c8032e12323c51913192"
    sha256 sonoma:         "ed0328f6f7b163264945926b607300fc3b029c7ac89b5c686d30cbc4b6a6394e"
    sha256 ventura:        "cab032e72f9da2b5716359d6806204b7aecd5c7c6f974d4bd30b75cbc641ace8"
    sha256 monterey:       "42a7fff5c48940a94450a650b30508a56f951d3e3b357f7b567159654fe511ae"
    sha256 x86_64_linux:   "fd46881af0315c55bf75c6afd44db57c9928421cb4e305a30ae782ba2a845bc1"
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