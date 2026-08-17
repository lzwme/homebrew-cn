class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  license "MIT"
  revision 5
  head "https://github.com/AliveToolkit/alive2.git", branch: "master"

  stable do
    url "https://github.com/AliveToolkit/alive2.git",
        tag:      "v21.0",
        revision: "913e1556032ee70a9ebf147b5a0c7e10086b7490"

    # Backport fix for LLVM 22
    patch do
      url "https://github.com/AliveToolkit/alive2/commit/a86aaa0ea44c5671ce3e998ec6d422feaa95b236.patch?full_index=1"
      sha256 "6645b59d29e7a4bbe45e91f57391cf9d4e5dbc27ba99a93c89ad13b14d57a7c4"
      type :backport
      resolves "https://github.com/AliveToolkit/alive2/pull/1265"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d8b384601767e9c413bced5f996d4263ff931464a2abf3af811ca81ac7c09b87"
    sha256 cellar: :any, arm64_sequoia: "9ab4bfa2e366f04f47c08cf051063482a3873f5f5269e25141c83f8b61365f9e"
    sha256 cellar: :any, arm64_sonoma:  "a21eb80647241c7eae74b3f4fa38ac8948ed3fe2ee009dd2d9052adf6bf8f37e"
    sha256 cellar: :any, sonoma:        "b34ccff603f47bacca8ab16dc91075250e1915a37cdf6d3455383622977d71bc"
    sha256 cellar: :any, arm64_linux:   "292adfebad8a79d09f5901e5251b2ec69ca3106a69c65d3fc33c652fc07e0ce1"
    sha256 cellar: :any, x86_64_linux:  "a6dedf169a09424f88927cf95fd7ecf71f6b29d15d3c0a6a6ffc9d5d55b53816"
  end

  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "hiredis"
  depends_on "llvm"
  depends_on "z3"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1500
    cause "error: reference to local binding 'src_data' declared in enclosing function 'IR::State::copyUBFromBB'"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_LLVM_UTILS=ON", "-DBUILD_TV=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      int main(void) { return 0; }
    C

    clang = formula_opt_bin("llvm")/"clang"
    system clang, "-O3", "test.c", "-S", "-emit-llvm",
                  "-fpass-plugin=#{lib/shared_library("tv")}",
                  "-Xclang", "-load",
                  "-Xclang", lib/shared_library("tv")
  end
end