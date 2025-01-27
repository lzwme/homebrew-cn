class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https:pkgx.sh"
  url "https:github.compkgxdevpkgxarchiverefstagsv2.1.3.tar.gz"
  sha256 "56d822bb4466e7e8bd8d558ba4d1ea5035d42509ecfc08c5ea8e39492eb3e7b8"
  license "Apache-2.0"
  head "https:github.compkgxdevpkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db861d5f844f07ff273f5bfffaaa426530f3a59c30c3087cbb81d43401d71fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "438816d6231a2560e73594f0777f77c80305eb9d94f71a0aa8e72c8cf9c024e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7eb9ed002eca692826701ab35f09b65ce9e5609cf7c0aa4819b3d812693b02c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5fe40e0067d15e4aa5e73ed7754d2c1f198ef9319612fd3cb04990c3c75c256"
    sha256 cellar: :any_skip_relocation, ventura:       "2c28ee5e5b8b86533f3a600b16715820c055be28954faf051d48a760e8545c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c5471617a2ddeca0689f1731e1aa49023bfc60dc325fb6d35d0c0029f8bbec4"
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