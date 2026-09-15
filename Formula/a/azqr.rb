class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.4.1.1",
      revision: "6fd30e5eebb178ceb129fdb9d0e67575840d5bc8"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bc284a6c5104a0262fe8aa6bbde2ab66705130ce8704139a982437a02cc08c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3bc284a6c5104a0262fe8aa6bbde2ab66705130ce8704139a982437a02cc08c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3bc284a6c5104a0262fe8aa6bbde2ab66705130ce8704139a982437a02cc08c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ac70aef59ac210ff049648d01a9b2d6237d86e72f433f8a2781006c30911220"
    sha256 cellar: :any,                 x86_64_linux:      "cf95c94fef85128f27988a0dc267cefa2063f8cff17dcf876cafcac3d2df92d4"
  end

  depends_on "go" => :build

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