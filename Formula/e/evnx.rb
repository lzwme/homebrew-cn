class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "f73ce6ecdc0f54684f2afe225a40fe7b8e550b95e1ee094c9e8c235cc58258db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "095942ff87d1b2d80c24100375df64d8b717c052cfac9a754402e45a0e85fd42"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da682e797312c8a97537271e8d138670cad436687acf4662e1e63ce999b7b823"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "645fd545f6abcad85a721fa36afb946bd2bdd76ad2c6b4d2003db3bfdad01d9f"
    sha256 cellar: :any,                 arm64_linux:       "c02bca1a94dafa6891b15681fc9de8e4d57926e59b46e339207a14b16a76ca9a"
    sha256 cellar: :any,                 x86_64_linux:      "f4f4d300c8ab48e7368e98408503074bd0e9bf00d1b8158e747f84103f4c8ff9"
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