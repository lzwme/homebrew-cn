class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/cabinpkg/cabin"
  url "https://ghfast.top/https://github.com/cabinpkg/cabin/archive/refs/tags/0.13.0.tar.gz"
  sha256 "f9115bb0566800beedb41106e00f44a7eaf1dea0fa6528281e31de5f80864177"
  license "Apache-2.0"
  revision 2
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e97d0864c66bf62ea7b014024bf7585c0069bd397ab840fc97725b4b4729f9e"
    sha256 cellar: :any,                 arm64_sequoia: "c1dcf1c02d972158e65e66c8bc62c2d01509f5b42f45603d7394cff059fc5e1d"
    sha256 cellar: :any,                 arm64_sonoma:  "e9dcb2901837d96250d350e5c230b7a88c1bef5abd332936386f98cced784991"
    sha256 cellar: :any,                 sonoma:        "ef94594fcddda52162028ea8a91fcba55cf171219d3eb993464bd286363afebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "233a2a68624ff57281778ea8496adc10d341fd0dd9e0b02ea72ec5b2da356c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d80d56f13208f944f50bdec29141ca1133a857f78952f9c9eb43a0c36e2e1d7d"
  end

  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "toml11" => :build

  depends_on "curl"
  depends_on "fmt"
  depends_on "libgit2"
  depends_on "pkgconf"
  depends_on "spdlog"
  depends_on "tbb"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    # Ventura seems to be missing the `source_location` header.
    depends_on "llvm" => :build
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  # allow to build with fmt 12.1.0, upstream pr ref, https://github.com/cabinpkg/cabin/pull/1231
  patch do
    url "https://github.com/cabinpkg/cabin/commit/b506326b996cd4d5a6578ceb5bbbb7a903dbdf12.patch?full_index=1"
    sha256 "baf74ab11f7a1f7e2a75916acdc7fed76114e24f02e09d057c261b2e469e5203"
  end

  def install
    # Avoid cloning `toml11` at build-time.
    (buildpath/"build/DEPS/toml11").install_symlink Formula["toml11"].opt_include
    system "make", "BUILD=release", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"cabin", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}/cabin run").split("\n").last
    end
  end
end