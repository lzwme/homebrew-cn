class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.17.tar.gz"
  sha256 "320fa9e065c6d04233f4035b729e4c251d863362c47e73aa6546cf4da5d216b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b17a4b932dcedc168c0ef94112d41ebcb01977783fa960c0de42f63b2bf3ba14"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6a28fd8604110313a8a146f7e80a13e6526a9370a2a144cb866ff1873132aaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae1e0119fb6d0899e425bc30f06335a9fcaa25f019aa6a6051bf3086d70bf289"
    sha256 cellar: :any,                 arm64_linux:       "116b7e2ef690846eefafc911c444a3f79b3ff420ff9325f676b0258c79692137"
    sha256 cellar: :any,                 x86_64_linux:      "944c0c24abc96a5ad6232844b255ca1b54e65b294705a9b5e67f543c661ac500"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end