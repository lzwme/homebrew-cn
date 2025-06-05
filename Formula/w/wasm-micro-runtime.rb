class WasmMicroRuntime < Formula
  desc "WebAssembly Micro Runtime (WAMR)"
  homepage "https:github.combytecodealliancewasm-micro-runtime"
  url "https:github.combytecodealliancewasm-micro-runtimearchiverefstagsWAMR-2.3.1.tar.gz"
  sha256 "542d93386f032101635e7f7cf67bdd172adfe2d49dd9eb92c0bbea5cfafd1f8e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-micro-runtime.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af5a780a67b959763af54a84f04735ae08dedcf875b47239c7c1d8818e853bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "601507a90145eedf4375868e0a677da1c8c5e92644034c1f2aef5686d82f78fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c20a57b03e8406fd4fa41ba649eda1cad3dd31b12721b452e133cfd820350042"
    sha256 cellar: :any_skip_relocation, sonoma:        "15ad738e55e90ebf8ed18decde0f602322cc3a28bb40752477f21448adf9149b"
    sha256 cellar: :any_skip_relocation, ventura:       "54cceb44867c377f535b5cc2e138be625270f7cc502a88d43c7e68f712c1f714"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a3663b8f8f3940ac2031397b13be3550f6e51dd4ea62cfdf0a26a01113b1651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f203e11bfa5ced6d8e4dfca93070e0b1739e88427fe73a729510100aa2509bdd"
  end

  depends_on "cmake" => :build

  def install
    # Prevent CMake from downloading and building things on its own.
    buildpath.glob("**build_llvm*").map(&:unlink)
    buildpath.glob("**libc_uvwasi.cmake").map(&:unlink)
    cmake_args = %w[
      -DWAMR_BUILD_MULTI_MODULE=1
      -DWAMR_BUILD_DUMP_CALL_STACK=1
      -DWAMR_BUILD_JIT=0
      -DWAMR_BUILD_LIBC_UVWASI=0
      -DCMAKE_STRIP=0
      -DWAMR_BUILD_SIMD=0
    ]
    cmake_source = buildpath"product-miniplatforms"OS.kernel_name.downcase

    # First build the CLI which has its own CMake build configuration
    system "cmake", "-S", cmake_source, "-B", "platform_build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "platform_build"
    system "cmake", "--install", "platform_build"

    # As a second step build and install the shared library and the C headers
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-fib_wasm" do
      url "https:github.comwasm3wasm3rawmaintestlangfib.c.wasm"
      sha256 "e6fafc5913921693101307569fc1159d4355998249ca8d42d540015433d25664"
    end

    resource("homebrew-fib_wasm").stage testpath

    output = shell_output("#{bin}iwasm -f fib #{testpath}fib.c.wasm 2>&1", 1)
    assert_match "Exception: invalid input argument count", output

    assert_match version.to_s, shell_output("#{bin}iwasm --version")
  end
end