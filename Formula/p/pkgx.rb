class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https:pkgx.sh"
  url "https:github.compkgxdevpkgxarchiverefstagsv2.5.tar.gz"
  sha256 "6ee84de61a8a709d611f19cb9ededf64c0e1042321d65f0c3376f4c00ee0d1ed"
  license "Apache-2.0"
  head "https:github.compkgxdevpkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7af54732855aca9600b8a930a69bd3f131dbb4f86730cb5a01ff9de7ec94f18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6973ad6241abffed7af771f14769b467ef46403ae205c9c6bb4564c3a524cc65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "813b9144cfc304d2fefbc702bff27c093efcf4c9eb965658e9836fcd6280b53f"
    sha256 cellar: :any_skip_relocation, sonoma:        "85a8fa7f27025f2c599a813bf18cd670c5a5a8d4a0ef7cdf63a5ef61495c589d"
    sha256 cellar: :any_skip_relocation, ventura:       "d4b952960612967dd03b8a763fc23f5d52fb15f4c51a0eaabf6fc57dbadf22fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d3dbe9e78ae2b533a69de8c91205974940633591c9bfdfac4511eab812156d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3111f0b32ad8ba4f3fb048f88e13f993be167959b07a520457a6b93610b1ff23"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cratescli")
  end

  test do
    (testpath"main.go").write <<~GO
      package main

      func main() {
        println("Hello world")
      }
    GO
    assert_match "1.23", shell_output("#{bin}pkgx go@1.23 version")
    assert_match "Hello world", shell_output("#{bin}pkgx go@1.23 run main.go 2>&1")
  end
end