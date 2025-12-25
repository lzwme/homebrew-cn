class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.14.0",
      revision: "cee1b0429e1db489e2f632f70c412143be55e926"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5e0f8214be8ab6f02e3fb0b1e553390020403b49cf04d9c24c2a0814c807c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5e0f8214be8ab6f02e3fb0b1e553390020403b49cf04d9c24c2a0814c807c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5e0f8214be8ab6f02e3fb0b1e553390020403b49cf04d9c24c2a0814c807c49"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ecb85e269974b2f26b78dfcb316d24ce7ebe2e0f64a46907a339d3f36d630f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec7985d880b5323ca703735b4d3aff51ea5631b047a4ea69b9ba91552af5dd1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a60b0b0b0492a657927c916ae961b13e1172045024bdb681efe0682a4249e558"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
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