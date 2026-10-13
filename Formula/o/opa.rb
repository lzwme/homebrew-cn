class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "ae553c9cc7f13a1443b3434e10ed83ba770d874168b2f00431225853e3dca9ff"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2fd560542beeb5ace7f93e016aea897b9772d58892850623f8ba75fca8fce672"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3779656261679f2401a3f186626e13c968a45f1fdab42786b150e44701faedda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb3c2a99eaa3234367e1a35a374d46146dc3ad202c38ca0922bac604c269b565"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d2084f4c53217222176488646a491f3deaa4112240cb4e34052a3b60e473bbd3"
    sha256 cellar: :any,                 x86_64_linux:      "455a2e401f337d497728cb1f673f7e48309cc5e12a6f08eeefe04db0172cfa82"
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