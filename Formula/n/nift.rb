class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "e64ebd8cec55308a844135446374267a5311bca1e7122ad951c887fcc20bc527"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db4a32727ce9fcee1280e0d11e86a575198b67ffbb6bbcc04279e55f6d3339b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f861d5fde718edb14416d605e09e1a247356bddcf6f7f1cd76b10c42bddbbf8"
    sha256 cellar: :any,                 arm64_sequoia:     "f56e2e40a6d911b05e40888ad8dc697738babc5b06752a48cfa93b8fa45e7e16"
    sha256 cellar: :any,                 arm64_linux:       "44c6ed7524ac1e7b9cef2e30b7d1cd28f6d4cc6d51170a14aff17def95c7961b"
    sha256 cellar: :any,                 x86_64_linux:      "d31ac1e65829d86f1c9d842491aacd0e87b4dc6f2ff28b57c145f5ed12d591b8"
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