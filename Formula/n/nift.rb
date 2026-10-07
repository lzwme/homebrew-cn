class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.7.2.tar.gz"
  sha256 "5a03b69973f0ec9e83cff3091355339309a679be46d525e196a20955df10bec3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f732115c351c902b81c9b3c49e27105fb52e00d8057ebf407db9e02b55c858dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "462bf81bfca9ea1354e489e916a5a9a149751415b8eda154017db0c1058cf185"
    sha256 cellar: :any,                 arm64_sequoia:     "e275b050ab1651483b301d26592c2a89752ef4feebed32b5ab4e98256559c685"
    sha256 cellar: :any,                 arm64_linux:       "a20f7718dd07df99d839c8dcc7dfbd224d3ff8ee82904212b917d219a8e79d98"
    sha256 cellar: :any,                 x86_64_linux:      "f99f908e55b4606b48a27867e143275051bad7ef88bc5e48dd70d87fc04fcece"
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