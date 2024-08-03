class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.4.tar.gz"
  sha256 "a1105023795b3e1b9abc29c088cdec5464cc9f3b640b5078dc90a505498da5ff"
  license "GPL-3.0-or-later"
  revision 4
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "290ee0ea8a725930cce60c249f0ace7eb1fd2f4d3aaabb5f1893ca6fd35a8615"
    sha256 arm64_ventura:  "f32a5c54efb5d380c9b53350215ed9490b621d517aa11a32bdcb484e94584c14"
    sha256 arm64_monterey: "b32686dde67f095be2c3bd15c5c1608eec16f89d720e8f6bae93f95bea187150"
    sha256 sonoma:         "6a9872fe6a35d0647073b08c9bc28b1d9f851a326830eb1319ad6c76698b025d"
    sha256 ventura:        "bf3d104c7e649d45153e5a8cae6bb9682375c581b914bbb09f66997f8e79f08c"
    sha256 monterey:       "6cd9f3586477831d87cc49c2314eb45813b86b413aea2b2d8a3a77bbdc63903b"
    sha256 x86_64_linux:   "c915c65f4598470f14f0a8c477f3a6fecd81c3eb4b5b9f957d45035406ee8a59"
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