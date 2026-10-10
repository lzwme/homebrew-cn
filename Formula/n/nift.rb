class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "5cdb63eb0f875c92010436eae11fabef2b31271daa266ac2f0c9a470bd5ef1cb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f83bcd0f8d9ec5fd2c63fcf3ef37a24b3048bd68c9d33ed7096195a330d7641"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7a1d851c0e2e717897cc45a526ec30d9d5039a404f3e8833778254b0fe23ac3"
    sha256 cellar: :any,                 arm64_sequoia:     "231b79a65ec7304fa954f9ab85951973a1e58a17c8f36ada515351f77f1f3024"
    sha256 cellar: :any,                 arm64_linux:       "086ee0945c774165cc6a2e661f4331c865f347e600cd2bc96282bc32672ae47c"
    sha256 cellar: :any,                 x86_64_linux:      "8f466d2f98d93db2f8ee11403e2c0e3c5bd83c1acd920e1a62b931004bd2fd4c"
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