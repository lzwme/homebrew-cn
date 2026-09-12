class Wasm3 < Formula
  desc "High performance WebAssembly interpreter"
  homepage "https://twitter.com/wasm3_engine"
  url "https://ghfast.top/https://github.com/wasm3/wasm3/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "50a6b26b46648f037d58ba5ed7f1d1c48b67506cbb12e1fbe222e6c1b64a6a6e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "83cc89988f71fa8c121cafda8b054cad13d895143853fcaefb2d578c98dbd8db"
    sha256 cellar: :any, arm64_tahoe:       "31565b2e90076356acade5526f519432b39f4b0d0e31ace4e80a233220130dad"
    sha256 cellar: :any, arm64_sequoia:     "5d3741f7e7d4b6320371e30df0fe3fba9c216d0d8f6ec575b702bffe07b4c6ce"
    sha256 cellar: :any, arm64_sonoma:      "4950261405d38dc03439d603b806d1560503c2794c7c424004e75417fb7a3952"
    sha256 cellar: :any, arm64_linux:       "6dfa9d9ed596a0d79a5d80fa733b31f50668f93c5e6c45878c1beafba9edbea3"
    sha256 cellar: :any, x86_64_linux:      "153e1796dcf2d879a659bfe41d49ad07b3686f4b4f020c82981cdcfe3cb1f3f5"
  end

  depends_on "cmake" => :build
  depends_on "uvwasi"

  def install
    # Unbundle uvwasi and link to shared library
    inreplace "CMakeLists.txt",
              "target_link_libraries(${OUT_FILE} uvwasi_a uv_a)",
              "target_link_libraries(${OUT_FILE} uvwasi::uvwasi)"

    # We bypass brew's dependency provider to set `FETCHCONTENT_TRY_FIND_PACKAGE_MODE`
    # which redirects FetchContent_Declare() to find_package() and helps find our `uvwasi`.
    # To re-block fetches, we use the not-recommended `FETCHCONTENT_FULLY_DISCONNECTED`.
    system "cmake", "-S", ".", "-B", "build",
                    "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
                    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
                    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS",
                    *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/wasm3"
  end

  test do
    resource "homebrew-fib32.wasm" do
      url "https://github.com/wasm3/wasm3/raw/ae7b69b6d2f4d8561c907d1714d7e68b48cddd9e/test/lang/fib32.wasm"
      sha256 "80073d9035c403b6caf62252600c5bda29cf2fb5e3f814ba723640fe047a6b87"
    end

    testpath.install resource("homebrew-fib32.wasm")

    # Run function fib(24) and check the result is 46368
    assert_equal "Result: 46368", shell_output("#{bin}/wasm3 --func fib fib32.wasm 24 2>&1").strip
  end
end