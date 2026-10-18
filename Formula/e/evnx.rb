class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "641758873821d57687367e10b64387517ceb1b159473a52eb93f0b1b3ff441d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6a9c7b1d806fea40e09a09ebfdec39bcd6371c4f26699ae91d80d353a44799c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb7b2a0e1ca5443ed2159458c18e98e42e84a185433e7fda96fb5ecb20bab3ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da096a6b27a401602fa96642a18813acbc637946bff70f0acb71508ceff1d404"
    sha256 cellar: :any,                 arm64_linux:       "db41b5e43209cfa52ff9df7aa326875a845c2aa6dbf72922444d60d645c5ebd8"
    sha256 cellar: :any,                 x86_64_linux:      "f7eea276299f071a75cac2ae40069a7cd8c35052208d06081c5508bfca6edc02"
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