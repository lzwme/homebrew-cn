class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.14.tar.gz"
  sha256 "ecf00d0dd039fb31b34b750ba4648a70cd40aa1e6c3d0a71d3c851550d61d2a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "517a71161b40dc751b6560b4650cf09f3285572e69e6b59fb987922769f791fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "322da4dec17dde02b5627b30c6398e1a7de3ae34f988df1892fb8c68441fba51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "faf46fd1bacaeaa5a4e504a03a96876fa270ee90daf353c0c788c7d4341e8251"
    sha256 cellar: :any,                 arm64_linux:       "45c0a58b1490ef5cbe57b3c53928fab6d8c0d209734f7877e6a3f00a02a240b0"
    sha256 cellar: :any,                 x86_64_linux:      "971dc5a51857fa4d585516d59ef1f6b03ad603d024d3e89cf35ff564f1c8c400"
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