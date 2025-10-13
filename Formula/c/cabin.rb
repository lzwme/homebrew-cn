class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/cabinpkg/cabin"
  url "https://ghfast.top/https://github.com/cabinpkg/cabin/archive/refs/tags/0.13.0.tar.gz"
  sha256 "f9115bb0566800beedb41106e00f44a7eaf1dea0fa6528281e31de5f80864177"
  license "Apache-2.0"
  revision 1
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "663856f27130718ab2546ab4eecdca21d0fabaa3f5c08169657f4d133b7a2d5a"
    sha256 cellar: :any,                 arm64_sequoia: "5cf95ebb404457edc95d68dc4c3bb5b20b8f17e8adce3798679ee497c5ea1ca1"
    sha256 cellar: :any,                 arm64_sonoma:  "ca1d58b0198c1b4afbd3942b147c852483d8a4931f3531a4c5068c4778824328"
    sha256 cellar: :any,                 sonoma:        "a71e816c3a97a91803ad64a6cbda528159f3a8bc4c7aa5793ada1603972bcf5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dced8bcac90d26d06ef4174d1414ef2489b23fe9533c546f529caa85a4a6a6d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa46ee698d680709a16f68238b437eef55ad01b75cc64aa53844da3f397f2323"
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