class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "745cf97f51da25428bf6f93cad42a9b25a039b8745eda5a3c710476477ad5138"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab88f26d602d805f247605bed18fddd5861b10d5894236de654b15768101d44b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70b88900291c517c5a92cf08a6064c503e866433e60cf3c8ccd625541b5c393b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "453ce4334f8c3abe4730ece43f7a11b7faf8ae27f465ef6acff2b9754b4b9077"
    sha256 cellar: :any,                 arm64_linux:       "5fea44feba405677ee9e20b082f11c624896d32fa8677f0e8c89c6977aa4b58b"
    sha256 cellar: :any,                 x86_64_linux:      "5a936efd10a55920630a8943a45d46daac8540fff5ebc7c7961040ddf0259dc9"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"sofka", "completion")
  end

  test do
    assert_equal "sofka #{version}\n", shell_output("#{bin}/sofka --version")
    assert_match "failed to read kubeconfig", shell_output("#{bin}/sofka --check 2>&1", 1)
  end
end