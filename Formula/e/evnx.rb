class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e9190340a022883a6a19bfe0bff90b1199f69f986473c8913288b74a2acc0de4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff12149e8a9d2971d747cb5ab38b9d7e27170af4cab6dc13fbac8d2fa7690a78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "216fedaeda7fdb02259a5aa844bf73829e71bc9dab7706a1b87e20982de7ebbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "057800924f64592f3a87768b606643013f0a59f650c484dcce8c3545fdb72531"
    sha256 cellar: :any,                 arm64_linux:       "7edfcebe3b487d235f6e9ebcfe91f9272e660159217f9970c3dfe68dfb97e514"
    sha256 cellar: :any,                 x86_64_linux:      "bef2bb2e794c2db50a3dd6284118933cd18a96fac7b1750a727b27c3d6573b40"
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