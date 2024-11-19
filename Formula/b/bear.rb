class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  revision 5
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "f648b4c8202aee98d0367a7ce3bb371b4113528ffd626b84753f709099386c3b"
    sha256 arm64_sonoma:  "a44838f0e8a760b1dc45866dab23d815f5c7b9842abf86cb4f8fe113890662b7"
    sha256 arm64_ventura: "964dc3f462f62a23ca4209e5e1f09f34dd32ca370d43f2471cd5bcb80c826663"
    sha256 sonoma:        "fd6b815e468c985f7d356f3657e9904bc8c9528157387ae2bfbc661f290d0213"
    sha256 ventura:       "e859fa298d384c43f674cde683e573bf6b0fec8df8379f2c18fc2d0c00946db6"
    sha256 x86_64_linux:  "0414f6eed5fee14d856379af50a65f0b1cbd3de6a36673f38ee46e463a3f646b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
    (testpath"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin"bear", "--", "clang", "test.c"
    assert_path_exists testpath"compile_commands.json"
  end
end