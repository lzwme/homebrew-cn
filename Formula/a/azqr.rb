class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.4.3.0",
      revision: "62bde8f9d2fecf9010c94b5c5a73b14e5f9783d6"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "037b14e3b0c43d89d986981634058df2edecfcad5157e8c3aeb0d1e9ac59d2e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "037b14e3b0c43d89d986981634058df2edecfcad5157e8c3aeb0d1e9ac59d2e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "037b14e3b0c43d89d986981634058df2edecfcad5157e8c3aeb0d1e9ac59d2e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "049a24d413f2416f28d286096b7c19cdbd47b617ee61c23a4f3b99a41d2d7c3d"
    sha256 cellar: :any,                 x86_64_linux:      "c6c5a655706314c170c4eaa7844a7b62347aecb99f6d3326145668e31ddc8a57"
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