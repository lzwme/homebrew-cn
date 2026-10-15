class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "0c066043d6a98955dfc12f594e18b454cd9d6da9519f2f36136800c6f73a5d8d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dcda6c6f0661c16b4ac65941a82af1c4bfa21beac9572b0150c073eaa039431a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9dfaad78bb30f0652827acb219c27739cfbf4e8c1652108b157505a5e2d9402a"
    sha256 cellar: :any,                 arm64_sequoia:     "89b665a917e69292c0e6e3870f517e33d63a0e8c5ff43fa83836de1bb8163a46"
    sha256 cellar: :any,                 arm64_linux:       "3bc5b59015594966a7e13216bcf662c37c1bbde975f6219774045d28ebfe3646"
    sha256 cellar: :any,                 x86_64_linux:      "1cc5ff86ccf24a0ec26fac0b7a7aa7ba9d9fec263a34d6474d9fc98d768b62a3"
  end

  uses_from_macos "python" => :build

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