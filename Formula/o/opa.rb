class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.21.4.tar.gz"
  sha256 "3cd7c22a0295a463dbef376c50a952e5b5d6c1d50b36535c6bcafd73167a2082"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c0b66eff431f7f6375c3d1ed9ef742d576bdc2a45c332d635edc558e4adc3e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "995ad2b0f693a72a808036c1edd7fb3a12a71dd0d0bc6b81df8778caaa8c1259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79d42f583e0ec9307137611e8bf032c40a2f50bb0a4e21dd106c67e7abd88946"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "43704bb76372a92450cf6ed6d62bcf009c304b1f33de9a02d2ccda10f6804e59"
    sha256 cellar: :any,                 x86_64_linux:      "4c8faba981c205e70f81716ac3a5d3859e2e2b23773c20fdd7e4eb196a8bc7b7"
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