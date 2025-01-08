class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https:github.comcabinpkgcabin"
  url "https:github.comcabinpkgcabinarchiverefstags0.11.1.tar.gz"
  sha256 "3c9bd2898e6fe692eb988dc71f22214ff938255ef2282d5d7d9c6bdf149d173f"
  license "Apache-2.0"
  head "https:github.comcabinpkgcabin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5754d0589d88d6cf7fd750294db721658108f990e4938f59111f28aa9ccb4114"
    sha256 cellar: :any,                 arm64_sonoma:  "83378766e873a19d9a4a152b5fc7d2a4544fa652cf057f36cbbe31e2158eebea"
    sha256 cellar: :any,                 arm64_ventura: "e0f4e105b71b65c16c7c0705cf337fa2c352b3f9b08c8988009690a5be45f1e1"
    sha256 cellar: :any,                 sonoma:        "0b7c588340d8a5d75ae08850a32601aee22b010dc291f2aec1be3dc6e4ced8b2"
    sha256 cellar: :any,                 ventura:       "18ee9f0222767ca6e8bacf2026b86802655b5ea3dd916d2bb484ebf900f3007e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a08d2c6df86d93a79c66300a2b34f85b9f3288778ddd9cb71ffb0119e416696"
  end

  depends_on "nlohmann-json" => :build
  depends_on "toml11" => :build
  depends_on "curl"
  depends_on "fmt"
  depends_on "libgit2@1.8"
  depends_on "pkgconf"
  depends_on "tbb"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  on_ventura do
    # Ventura seems to be missing the `source_location` header.
    depends_on "llvm" => [:build, :test]
  end

  on_linux do
    depends_on "gcc" # C++20
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200 || MacOS.version == :ventura)
    # Avoid cloning `toml11` at build-time.
    (buildpath"buildDEPStoml11").install_symlink Formula["toml11"].opt_include
    system "make", "RELEASE=1", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200 || MacOS.version == :ventura)
    system bin"cabin", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}cabin run").split("\n").last
    end
  end
end