class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https:github.comcabinpkgcabin"
  url "https:github.comcabinpkgcabinarchiverefstags0.11.0.tar.gz"
  sha256 "0ffefbfa8aa26a55c9acb058943a35a4d316ad13f588fee0c66ee5e16673e657"
  license "Apache-2.0"
  head "https:github.comcabinpkgcabin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "718a61b02f0570116f728f6781b324960c1befdcebb323b11e9a5579df070949"
    sha256 cellar: :any,                 arm64_sonoma:  "428beabf2dbf2d516fc142fed8d159876f10f4561cb830e48f85e1ea6092a788"
    sha256 cellar: :any,                 arm64_ventura: "93f89a86a5cbf309887eadb863631829e0c5fc899dd11c1c23f64d55323d0e47"
    sha256 cellar: :any,                 sonoma:        "05bbcea8035588f3d0fecf766109e7e69baee7c573b1e326126d8812f642cc0e"
    sha256 cellar: :any,                 ventura:       "f28c62b0d3c9ea57cdcd40b84beb17e57d9bb56f10043632f87a71f0e9da8100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e30409295c48daf0a199dfdaee56914cd22cfc2601923c72be7e16031a1234f3"
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