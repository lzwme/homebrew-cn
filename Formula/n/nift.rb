class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "363b6f5fbf50eb5bb9f6e621d06e490104a0aa8ded5662322658ddc794c1054f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4fabc89b803df3bae4c86110ee1309863f259ffd862e011e5c15538669f95740"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ffbb73e74214d8fa1b084646ce2c89c72949eda877ba36a8db0d45ffab3c171"
    sha256 cellar: :any,                 arm64_sequoia:     "ae2f5c675f0ee69061d0d863d6e84164a5337fb7fa27ddd98d5e090ed485fb04"
    sha256 cellar: :any,                 arm64_linux:       "05cd85cc90f12a16ced591ec57cfba12e2426581bb7d76caafa00dea27e7ef8e"
    sha256 cellar: :any,                 x86_64_linux:      "9fee1310094ca8c114c3fcd7aa500d6068c736ca0d5d8e8b81f158df2ff16532"
  end

  depends_on "python@3.14" => :build

  on_sequoia :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "floating-point `std::from_chars` requires macOS 26 libc++"
    end
  end

  deny_network_access!

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