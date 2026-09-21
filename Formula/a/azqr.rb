class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.4.1.2",
      revision: "e85b9f9d9ca60e5c8b3085c2c6077a785be1a0a3"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d42ca303ec70706aa6f62099a22979261b7d3b2c37997b8d68a2a13df515a6d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d42ca303ec70706aa6f62099a22979261b7d3b2c37997b8d68a2a13df515a6d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d42ca303ec70706aa6f62099a22979261b7d3b2c37997b8d68a2a13df515a6d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "83c0ae2c293df13d75d6dd6c09043436977d3ce1ee278dbd34b4f30ffbce6aa3"
    sha256 cellar: :any,                 x86_64_linux:      "6d32e29eed828580472273d1276fd3f141f017c1dbd3471a2a1378d61554ad9a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end