class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "8f43cec4fb0a520cfa8e5a95612e3d370af3676555ffd7d4d32d81005f7ba5c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26a23b0304ef8d6bfb88341aab1afa3e9256086619654d0d4c7a0b5b3219e39e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fb178f7f1ce8eead187a9597c6776f85ec22647a2aeaee4ae0c5adf7720044c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0592698881cd6b4118908c0ea8383e3def642f925660cb7a991d584fcf047f13"
    sha256 cellar: :any,                 arm64_linux:       "8a690fedabf1e6787387c4459752002f46024d8b1b6894c92787da37df6d280c"
    sha256 cellar: :any,                 x86_64_linux:      "7f10b7f528692ac14b3fcb86f860c0a3846785e45eef1e8b02ae19d72defdfc4"
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