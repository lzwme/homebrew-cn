class Legba < Formula
  desc "Multiprotocol credentials bruteforcer/password sprayer and enumerator"
  homepage "https://github.com/evilsocket/legba"
  url "https://ghfast.top/https://github.com/evilsocket/legba/archive/refs/tags/1.1.1.tar.gz"
  sha256 "a5c7254b19910e2b1816a9e4af3720b772e35d1b0491cb42f90564ca01699d6f"
  license "AGPL-3.0-only"
  head "https://github.com/evilsocket/legba.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d48ecb4ef2aae78b223236a2eaa630633bc21a1c236d1fc4b98c878e32b6bde0"
    sha256 cellar: :any,                 arm64_sonoma:  "8347f17bb79cfa0b052a048fd61f082583b6daf788f11e46cec0322d88fe8c03"
    sha256 cellar: :any,                 arm64_ventura: "f20c77d7f9a6ec1173d2871152104e3f6e84225466363092d357354df8e37f47"
    sha256 cellar: :any,                 sonoma:        "f96f0db780c2b7bbf111b7618d33cf00b0a9284a1f54a35c2df1f8484110e123"
    sha256 cellar: :any,                 ventura:       "62757237d0e8fd9453f6ee9b5610f3b0c17fb137cb8d67b3db2e0c9dc08de70e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9842c12060cf83ffc70b9d6264889b72790a7df2e19a00ae9ee5cb2363b4faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1602ac182c88053c8a3b9a35513d3216797190420f93ae65582fb049bd2ed68a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "samba"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"legba", "--generate-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/legba --version")

    output = shell_output("#{bin}/legba --list-plugins")
    assert_match "Samba password authentication", output
  end
end