class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.16.0",
      revision: "926296dde55c5ac36901d68c96bb62de24d295b0"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed4f85f81a679c20b775e608052d537e123fcd828d57f9f98eef3845b9a67e6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed4f85f81a679c20b775e608052d537e123fcd828d57f9f98eef3845b9a67e6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed4f85f81a679c20b775e608052d537e123fcd828d57f9f98eef3845b9a67e6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "14a763e9ee2fc2e5ffef47f9de2ca109d97c207f665d056a02e66831162e8589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1adc69e815879d337213eb2373ef6e8bbd9e18adc8bb924bd530d77bfdc8aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d43a34403e2d9e6d9bf51d2a4571e432b909f8442f106bad44b7a958705c452"
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