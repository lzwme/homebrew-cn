class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https:github.compoac-devpoac"
  license "Apache-2.0"
  revision 1
  head "https:github.compoac-devpoac.git", branch: "main"

  stable do
    url "https:github.compoac-devpoacarchiverefstags0.10.1.tar.gz"
    sha256 "4be4f9d80ee1b4b2dd489bc335d59b50d945ad2bff9458eba66b230247f5c8a6"

    # Backport build fix for tbb 2022
    patch do
      url "https:github.compoac-devpoaccommit97cc65443b8d0a938a9cfdbfbbbe4b83f73976a8.patch?full_index=1"
      sha256 "f3d5885a17ce00cc7f1568504a128f36704875bd41a66d7dcbfcdc3e7d53c538"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b59fe0ef52277fad2ae5d782698269a20b4f76da7572f009bb9753250436294"
    sha256 cellar: :any,                 arm64_sonoma:  "e3ffa74cffc03297da642ffcd88494ebf6321ff5f28d9d490b4d6442063e9c2a"
    sha256 cellar: :any,                 arm64_ventura: "d134b1699bc23c5417e436353bf137324673cabb3f75e30581da198f0880fbbc"
    sha256 cellar: :any,                 sonoma:        "f984260fc9eb74014e100ff527f1a1b2b86173c936156aaaa4fac1bac1e206eb"
    sha256 cellar: :any,                 ventura:       "97a2d76d91cd9035498bd323505f5ad9642337a8e227fdda5871c2f36a938cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "366b2f3e0a2e2d59ff46e452a632ac40c4c0c0d827f19889b8d3f1390cdc77d6"
  end

  depends_on "nlohmann-json" => :build
  depends_on "toml11" => :build
  depends_on "curl"
  depends_on "fmt"
  depends_on "libgit2"
  depends_on "pkgconf"
  depends_on "tbb"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
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
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    # Avoid cloning `toml11` at build-time.
    (buildpath"build-outDEPStoml11").install_symlink Formula["toml11"].opt_include
    system "make", "RELEASE=1", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system bin"poac", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}poac run").split("\n").last
    end
  end
end