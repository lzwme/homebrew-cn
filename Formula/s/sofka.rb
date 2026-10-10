class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.5.tar.gz"
  sha256 "f1a599f4115c4ab75d991d0467d4cce78b26d136de1ff1fc6b03e3cd1e771915"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d9011b6400cd7af7fed4b831b5506feab37531c5aa4372a15f288ccf2a8ad43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b02410ba73258207beb18cde408f3f4018cac5d49177b43ed5963a581147a08a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d27cb10043b94f262b324e4968d53b4d57f6396614c556f647db52f305a521e3"
    sha256 cellar: :any,                 arm64_linux:       "b0e178485caae8c53201241ee0555ab754c4648e5e18a9fb1b0824eedae98b90"
    sha256 cellar: :any,                 x86_64_linux:      "3f0b894f47ceccaa1b0cad6f44fdcda8720c75f0102f92e8c90e1a1091c5a3c3"
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