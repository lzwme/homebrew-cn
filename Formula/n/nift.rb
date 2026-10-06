class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "dee0c59e102abda6f5fe09cf0911860a53a9a2b3b061bc62b599cd81ff47b28c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82ea9e17f3bf749701b323a5379a4546dcd229a2b42bf0b38505f1c2c10564df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa514c538bee8b7e544c73e339c68b4359e206d2df5691a7ed81ed776d17aadb"
    sha256 cellar: :any,                 arm64_sequoia:     "3a20b4358111e66c1c356b4639de63e9262602ccf3ed3ed8ae46079b727e3f66"
    sha256 cellar: :any,                 arm64_linux:       "c9ba3d566bed759197ea0e2457b75488080b731df4c16e43a33a81376c8fdb39"
    sha256 cellar: :any,                 x86_64_linux:      "f2504f6efa40c6f7ea22ffd40a4b0388be70785349eb53183846caeae344a5dc"
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