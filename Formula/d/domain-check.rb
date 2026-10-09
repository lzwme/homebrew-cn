class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://ghfast.top/https://github.com/saidutt46/domain-check/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "108531f35045c075cae3215c6a9d3a2aa9c57d980a357795c58f1762760aa8a3"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "893fcd276a36a263d148b5844a6aa98ff5327010e334a100bb3e0b6347d2b653"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea109717560a2c002807f5792b71010ca2f1c3cc4867fc82343a0f7eced66d82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "306e15359d9e32c5877dad5dae3f0d0d9c22d26c4ff2a65f7131f6c84f253c82"
    sha256 cellar: :any,                 arm64_linux:       "828612b7f9e8b19a1998f921bb76550240236a89ceb2a28f8806aa3fcd59f85e"
    sha256 cellar: :any,                 x86_64_linux:      "68c991a1dac47fe38716cc7d1c210e5f3bead2d5ef188dab427635d96a19e0f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "domain-check")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/domain-check --version")

    output = shell_output("#{bin}/domain-check example.com")
    assert_match "example.com TAKEN", output

    output = shell_output("#{bin}/domain-check invalid_domain 2>&1", 1)
    assert_match "Error: No valid domains found to check", output
  end
end