class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "8989ae9dfc1a0e5406eed6a65fcecca97a0f1f57f50b533c97e65f06643ec275"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fab2a0c0d5a91b8f0cb27ecb13d3524a7d0d1755657769a6b302d8fe2a955865"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58acf7d876a865fb0c9589e052315da1a6cc67c164a333c29784db6f1debc6cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e8bfc5720fda19a280e0e4af6c75988a36a585ab2db4dbc0981b16c8e696fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b714543df5d08b53a723ab3e8827114300e8fe2c6614ce82b1100bf62cbf52e7"
    sha256 cellar: :any,                 x86_64_linux:      "32555f29d34bc67cf657016b98e3446dd7a69a617fea9e3de0d47e55929fdfb4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/open-policy-agent/opa/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end