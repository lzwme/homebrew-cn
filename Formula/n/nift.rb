class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "296650e52053858b49a6817d8b22e4ee3690b283b311eefb7a11532c070cd6fd"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be9bab973e401efba39fba66c522a2b885f66d7cde09945d58da804562a9d074"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27ad616a4b118c195188de08779ad172aa62146fc00779219bdffb533f15d266"
    sha256 cellar: :any,                 arm64_sequoia:     "42a855005c1c5508e57ae4df25c206ffe136a1c5eaea1dc85f4a4bb3326c16b5"
    sha256 cellar: :any,                 arm64_linux:       "81f4d505edcf1082cfa01a57fd4585dc0fae0e7a6a95e1161a04a6250c683609"
    sha256 cellar: :any,                 x86_64_linux:      "beef657a88ac7dedfa66f04b226c2c31b1a1865b38065a2507e1980020d058b4"
  end

  on_sequoia :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "floating-point `std::from_chars` requires macOS 26 libc++"
    end
  end

  def install
    if OS.mac? && MacOS.version <= :sequoia
      # Link LLVM's libc++ as the system one lacks floating-point `std::from_chars` before macOS 26
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("llvm")/"c++"
      inreplace "Makefile", /^CXXFLAGS \?= /, "\\0-D_LIBCPP_DISABLE_AVAILABILITY "
    end

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end