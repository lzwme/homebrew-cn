class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://ghfast.top/https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "a549b8a72863c2ae39679ecf4b852772910d3d7f2a31682c2b79333e426e91f1"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "118eceb559421d0affec88563773fd9af8e8ec72efb398b8a830f9c79eab9f21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5d818375243f1b95c5387db24dca7d56a6fde7638774fee511c0edb372e8aee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f8564cd8dbc4b55b3a0422c02c42602e8d498f567de73ba0b08bbd90ef3804c"
    sha256 cellar: :any,                 arm64_linux:       "fb699e37f21fa9a5ebd9d6bfcb941030012d9214d2b6d8dd751a03164271cf6b"
    sha256 cellar: :any,                 x86_64_linux:      "9c5d4345e9271daae4b096d382d6af05a564c9b0b552bb4071e17d925712d27c"
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
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end