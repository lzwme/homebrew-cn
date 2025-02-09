class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https:pkgx.sh"
  url "https:github.compkgxdevpkgxarchiverefstagsv2.2.1.tar.gz"
  sha256 "bb00e996933ee90c74e42938b2365b9c2ab970e8493551a24df7b1c631a14fdb"
  license "Apache-2.0"
  head "https:github.compkgxdevpkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee062197df88e300a9e92f456e08e6eebae7af8421c27c745f526ed1b757dab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27b3fd1a3c039866e507e6441e29f5931841e933540238ac0373de93ac046842"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "843407423b854dd13714a92f6ee7a15dba8452798fe9d76eac13355aefa1e43b"
    sha256 cellar: :any_skip_relocation, sonoma:        "59788516da4423a32b6cf74bccb7238e979344d3517cf5a1104bf7942339ee14"
    sha256 cellar: :any_skip_relocation, ventura:       "053c708b0e26d1b955463dcb70ee8c285129550356f3a504ffce724956ae654e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ed8cc964bf85757cd62f1e0871f953f1bc9a05584e0cdb43e93f9e2c5dac4de"
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