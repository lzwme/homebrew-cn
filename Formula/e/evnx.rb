class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "d15f2e37fadf4ae44416a4732ea0e6256f45a1fe5c98b856769f1d8e06022243"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c081f9c9198daa78a71f77a31f6c42ecb1c7e728cf854b456690ab5e6ed5a96d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3e7175e505bfc0312d5d39696ef7c580b6dfa7089dbf3c22cefc73b725565aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84723734f90c0142b64b5314ee44a73152034d1cd4951d938d85fc8acb5f3e59"
    sha256 cellar: :any,                 arm64_linux:       "5d986b6decca72caf9357c741db8abbb28071915086cdb812a01eef75906ebe2"
    sha256 cellar: :any,                 x86_64_linux:      "6ab1773ce0b17895f118ce0c70cdc6a2c59aa32d25731be8ee78a038e6e72595"
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