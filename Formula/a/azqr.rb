class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.4.1.0",
      revision: "4edf82d545d63815b577a50f80eff4a93ca88f62"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d56b3f95fcec98e99b1847691d84eb1468981722314681735dbb0564c798d16d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d56b3f95fcec98e99b1847691d84eb1468981722314681735dbb0564c798d16d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56b3f95fcec98e99b1847691d84eb1468981722314681735dbb0564c798d16d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b16a8d0878c93784460586f6f9535fd80ab8aee41130549ed277e41a35ef2b07"
    sha256 cellar: :any,                 x86_64_linux:  "ca042fa3fd961fb013934d1d20ac6f202d545629d2e6534d2e3a9bee63c3e3f6"
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