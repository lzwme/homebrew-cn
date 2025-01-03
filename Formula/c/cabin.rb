class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https:github.comcabinpkgcabin"
  url "https:github.comcabinpkgcabinarchiverefstags0.11.0.tar.gz"
  sha256 "0ffefbfa8aa26a55c9acb058943a35a4d316ad13f588fee0c66ee5e16673e657"
  license "Apache-2.0"
  revision 1
  head "https:github.comcabinpkgcabin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c24a7739166e9d08a4cc7f883d3a90b6e8528dd7db622c970d2f53c994c59506"
    sha256 cellar: :any,                 arm64_sonoma:  "4438f8cd89a498219256b7844de9b129be12d30cdeab3ebcbef42c181dcc9e24"
    sha256 cellar: :any,                 arm64_ventura: "b266bbce28bcf942c16038b18c11a440f894b022f7411ea6e545158a2a2bc5ce"
    sha256 cellar: :any,                 sonoma:        "93ddb33c84187fe72debab940444dd25939637210d43eb392535e38231fcecbb"
    sha256 cellar: :any,                 ventura:       "553462ad734a97b0e7600d0821170cbe11f929668132cfb1aa0221ab28ad0a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07f5c88feb9dd1a7f6eff05fb0d1c87a33bb46413644eb1c6fa4052744c89319"
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